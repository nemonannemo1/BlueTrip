using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
using System;

public class PlayingDisplay : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI _display;

    String _textTemplate;
    bool _isGameScene = false;

    void Start()
    {
        _textTemplate = _display.text;
        _isGameScene = SceneManager.GetActiveScene().name == "Main";
    }

    void Update()
    {
        if (!_isGameScene)
        {
            return;
        }

        // テキストテンプレート内の @ を時刻に置き換え
        var text = _textTemplate
            .Replace("_TIME_", GameManager.playTime)
            .Replace("_RING_", GameManager.flowerRing.ToString())
            .Replace("_PORTAL_", GameManager.flyPortal.ToString());
        _display.text = text;
    }
}
