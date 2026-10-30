# APIS, AUDIO ENGINE & OFFLINE PIPELINE SPECIFICATION
**Paradigm:** Offline-First, Zero Paid Dependencies, Lossless Streaming  
**Target Public APIs:** Quran.com v4, EveryAyah CDN, Aladhan Prayer Engine  
**Audio Engine:** `just_audio` + `audio_service`

---

## 1. DATA SOURCES & NETWORK CONTRACTS

### Quran Text & Tafsir (`Quran.com API v4`)
- **Base URL:** `https://api.quran.com/api/v4/`
- **Fallback Rule:** All Quranic chapters, verses, page mappings, and concise Tafsir must be bundled inside a local SQLite asset database (`quran_v1.db`) on first launch. Remote API is only queried for supplementary translations, checksum verification, or updates.

### Audio Streaming Engine (`EveryAyah.com CDN`)
- **URL Pattern:** `https://everyayah.com/data/{reciter_identifier}/{surah_3_digit}{ayah_3_digit}.mp3`
  - Example: `https://everyayah.com/data/Alafasy_128kbps/001001.mp3` for Al-Fatiha, Verse 1.
- **Pre-buffering Requirement:** When verse $N$ starts playing, the background player must proactively pre-fetch verse $N+1$ into the local cache directory to guarantee gapless playback without latency.

---

## 2. OFFLINE-FIRST PERSISTENCE ARCHITECTURE
- **Storage Engines:**
  - **Relational Data (Quran Pages, Verses, Tafsir):** `sqflite` with composite indices:
    ```sql
    CREATE INDEX IF NOT EXISTS idx_ayahs_surah_ayah ON ayahs(surah_number, ayah_number);
    CREATE INDEX IF NOT EXISTS idx_ayahs_page ON ayahs(page_number);
    ```
  - **Key-Value & Preferences (Bookmarks, Audio position, Streaks):** `hive_flutter` or `flutter_secure_storage` with AES-256 local encryption.
- **Synchronization Logic:**
  ```
  User / Screen Request
         │
         ▼
  Query Local Cache (SQLite / Hive)
         │
  Found? ──► YES ──► Emit Local Data (Instant Paint, 0ms latency)
         │
        NO
         ▼
  Fetch Remote API (Dio with 8s timeout)
         │
  Success? ──► Cache to SQLite/Hive ──► Emit Fresh Data
         │
        Fail ──► Emit Typed Domain Failure (No Unhandled Crash)
  ```

---

## 3. AUDIO PLAYBACK & MEMORY RULES (`just_audio`)
- Manage audio playback strictly through a single isolated `AudioPlayerHandler` registered in `GetIt`.
- **Equalizer & Waveform Animation:** The audio engine must expose playback position and stream events to drive the tactile waveform visualizer in the presentation layer.
- **Sleep Timer Volume Ducking:** When the sleep timer triggers, the volume must smoothly step down over 15 seconds from 1.0 to 0.0 before invoking pause, avoiding abrupt audio cuts:
  ```dart
  Future<void> duckVolumeAndPause(AudioPlayer player) async {
    const steps = 15;
    for (int i = steps; i >= 0; i--) {
      await player.setVolume(i / steps);
      await Future.delayed(const Duration(seconds: 1));
    }
    await player.pause();
    await player.setVolume(1.0); // Reset for next play
  }
  ```
- **Mandatory Lifecycle Disposal:**
  ```dart
  @override
  Future<void> close() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    return super.close();
  }
  ```

---

## 4. STRICT NETWORK CLIENT PIPELINE (`Dio`)
All remote communication must pass through an enterprise-configured `Dio` instance with interceptors:
1. **Connectivity Check:** Verify active network interface via `connectivity_plus` before emitting HTTP requests; if offline, immediately throw `NoInternetException`.
2. **Exponential Backoff Retry:** Automatically retry transient 5xx HTTP codes up to 3 times with exponential backoff (1s, 2s, 4s).
3. **Graceful UI Degradation:** When an audio stream or API fails, display a non-intrusive tactile snackbar or retry pill instead of blocking dialog popups.

