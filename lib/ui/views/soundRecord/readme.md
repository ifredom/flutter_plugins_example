# soundRecord 录音

> flutter_sound: 8.4.2

## 特例

- 对于 ios 设备，当你在录音时，如果中途播放了其他声音(当前 APP 或者其他 APP 声音)，此时录音会被中断。需要设置额外参数 ：[SessionMode](https://www.cnblogs.com/xuan52rock/p/9400436.html)

```java
_flutterSoundPlayer?.openAudioSession(mode:SessionMode.XXX);
```

---

**Category 定义了七种主场景**

| Category                              | 是否允许音频播放/录音  | 是否打断其他不支持混音 APP | 是否会被静音键或锁屏键静音 |
| ------------------------------------- | ---------------------- | -------------------------- | -------------------------- |
| AVAudioSessionCategoryAmbient         | 只支持播放             | 否                         | 是                         |
| AVAudioSessionCategoryAudioProcessing | 不支持播放，不支持录制 | 是                         | 否                         |
| AVAudioSessionCategoryMultiRoute      | 支持播放，支持录制     | 是                         | 否                         |
| AVAudioSessionCategoryPlayAndRecord   | 支持播放，支持录制     | 默认 YES，可以重写为 NO    | 否                         |
| AVAudioSessionCategoryPlayback        | 只支持播放             | 默认 YES，可以重写为 NO    | 否                         |
| AVAudioSessionCategoryRecord          | 只支持录制             | 是                         | 否（锁屏下仍可录制）       |
| AVAudioSessionCategorySoloAmbient     | 只支持播放             | 是                         | 是                         |

**实际开发需求中有时候需要对 Category 进行微调整，我们发现这个接口还有两个参数 Mode 和 Options**

| 模式                             | 兼容的 Category                                                                                     | 场景                           |
| -------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------ |
| AVAudioSessionModeDefault        | All                                                                                                 | 默认模式                       |
| AVAudioSessionModeVoiceChat      | AVAudioSessionCategoryPlayAndRecord                                                                 | VoIP                           |
| AVAudioSessionModeGameChat       | AVAudioSessionCategoryPlayAndRecord                                                                 | 游戏录制，GKVoiceChat 自动设置 |
| AVAudioSessionModeVideoRecording | AVAudioSessionCategoryPlayAndRecord , AVAudioSessionCategoryRecord                                  | 录制视频                       |
| AVAudioSessionModeMoviePlayback  | AVAudioSessionCategoryPlayback                                                                      | 视频播放                       |
| AVAudioSessionModeMeasurement    | AVAudioSessionCategoryPlayAndRecord , AVAudioSessionCategoryRecord , AVAudioSessionCategoryPlayback | 最小系统                       |
| AVAudioSessionModeVideoChat      | AVAudioSessionCategoryPlayAndRecord                                                                 | 视频通话                       |
