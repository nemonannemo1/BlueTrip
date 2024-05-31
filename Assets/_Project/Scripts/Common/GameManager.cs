using UnityEngine;
using System;

public class GameManager : MonoBehaviour
{
    static int _flowerRing = 0;
    static int _flyPortal = 0;
    static float _playTime = 0;
    static bool _isGoalIn = false;
    static bool _enableCountTime = false;

    // フラワーリングを通った数
    public static int flowerRing { get { return _flowerRing; } }
    // ポータルを通った数
    public static float flyPortal { get { return _flyPortal; } }
    // プレイタイム（MM:SS形式）
    public static string playTime
    {
        get { return TimeSpan.FromSeconds(_playTime).ToString(@"mm\:ss"); }
    }
    // プレイタイム（秒数）
    public static float rowPlayTime { get { return _playTime; } }
    // ゴールインしたか
    public static bool isGoalIn { get { return _isGoalIn; } }

    public void Start()
    {
        Reset();
        CountStart();
    }

    public void Reset()
    {
        _flowerRing = 0;
        _flyPortal = 0;
        _playTime = 0;
        _isGoalIn = false;
        _enableCountTime = false;
    }

    public void Update()
    {
        if (_enableCountTime)
        {
            _playTime += Time.deltaTime;
        }
    }

    public static void CountStart()
    {
        _enableCountTime = true;
    }

    public static void AddFlowerRing() { _flowerRing += 1; }
    public static void AddFlyPortal() { _flyPortal += 1; }
    public static void GameClear()
    {
        _isGoalIn = true;
        _enableCountTime = false;
    }
}
