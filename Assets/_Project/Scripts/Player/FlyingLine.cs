using UnityEngine;

/**
 * プレイヤーの移動軌跡を描画する
 */
public class FlyingLine : MonoBehaviour
{
    const float TIME_SPAN = 1f;

    [SerializeField] FlyingPlayer _player;

    LineRenderer _line;
    float _currentTime = 0f;

    void Awake()
    {
        transform.parent = null;
        _player = FindObjectOfType<FlyingPlayer>();
    }

    void Start()
    {
        _line = GetComponent<LineRenderer>();
        _line.positionCount = 2;
        _line.SetPosition(0, _player.transform.position);
    }

    void Update()
    {
        _currentTime += Time.deltaTime;
        if (_currentTime > TIME_SPAN)
        {
            _line.positionCount++;
            _currentTime = 0f;
        }
        _line.SetPosition(_line.positionCount - 1, _player.transform.position);
    }
}
