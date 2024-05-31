using UnityEngine;
using TMPro;

public class EndingScore : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI _display;

    void Start()
    {
        var _textTemplate = _display.text;
        // テキストテンプレート内の @ を時刻に置き換え
        var text = _textTemplate
            .Replace("_TIME_", GameManager.playTime)
            .Replace("_RING_", GameManager.flowerRing.ToString())
            .Replace("_PORTAL_", GameManager.flyPortal.ToString());
        _display.text = text;
    }
}
