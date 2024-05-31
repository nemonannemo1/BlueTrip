using Utils;
using UnityEngine;
using System.Collections.Generic;

/**
 * デバッグ描画
 */
public class FlyingDebugger : MonoBehaviour
{
    const float CAMERA_FOV = 35f;
    const float CAMERA_FAR = 10f;
    const float CAMERA_NEAR = 0.1f;
    const float CAMERA_ASPECT = 1.777f;
    const float TIME_SPAN = 1f;
    readonly Vector3 ALTITUDE_PLANE = new Vector3(500f, 0f, 500f);

    [SerializeField] Color _cameraColor = Color.gray;
    [SerializeField] Color _movementColor = Color.gray;

    FlyingPlayer _player;
    Rigidbody _rigid;
    float _currentTime = 0f;
    List<Vector3> _linePos = new List<Vector3>();

    float _speed;
    float _altitude;
    string _mode;

    void Awake()
    {
        transform.parent = null;
        _player = FindObjectOfType<FlyingPlayer>();
        _rigid = _player.GetComponent<Rigidbody>();
    }

    void Start()
    {
        _linePos.Add(_player.transform.position);
    }

    void Update()
    {
        _currentTime += Time.deltaTime;
        if (_currentTime > TIME_SPAN)
        {
            _linePos.Add(_player.transform.position);
        }

        _speed = Mathf.Round(_player.speed * 100f) / 100f;
        _altitude = Mathf.Round(_player.altitude * 100f) / 100f;
        _mode = _player.isFlyMode ? "飛行" : "歩行";
    }

    // PCのみにデバッグ表示
    void OnGUI()
    {
        GUIStyle style = GUI.skin.label;
        GUIStyleState styleState = new GUIStyleState();
        styleState.textColor = Color.red;
        style.normal = styleState;

        var pos = new Rect(20, 20, 400, 20);
        GUI.Label(new Rect(pos), $"PC操作 矢印キーで前後と旋回。Zで急上昇 Xで急降下 スペースで急加速");
        pos.y += 20;
        GUI.Label(new Rect(pos), $"VR操作 左スティックで前後と旋回。左トリガーで急上昇 右トリガーで急降下");
        pos.y += 40;
        GUI.Label(new Rect(pos), $"モード: {_mode}");
        pos.y += 20;
        GUI.Label(new Rect(pos), $"速度: {_speed} 高度: {_altitude}");
        pos.y += 20;
        GUI.Label(pos, $"左右入力: {_player.inputH} 上下入力: {_player.inputV}");
        pos.y += 20;
        var swoopPose = _player.isSwoop ? "オン" : "オフ";
        GUI.Label(pos, $"両手の傾き: {_player.inputTilt} 急降下姿勢: {swoopPose}");
    }


#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (_player == null) return;
        if (_player != null && _rigid == null)
        {
            _rigid = _player.GetComponent<Rigidbody>();
        }

        if (Application.isPlaying)
        {
            _drawMovementLine();
        }

        _drawCamera();
        _drawVector();
        _drawRigidInfo();
        _drawLimitAltitude();
    }

    // 移動の軌跡を描画
    void _drawMovementLine()
    {
        Color tmpColor = Gizmos.color;
        Gizmos.color = _movementColor;
        for (int i = 1; i < _linePos.Count; i++)
        {
            Gizmos.DrawLine(_linePos[i - 1], _linePos[i]);
        }
        Gizmos.DrawLine(_linePos[^1], _player.transform.position);
        Gizmos.color = tmpColor;
    }

    // プレイヤーの視界領域を描画
    void _drawCamera()
    {
        Color tmpColor = Gizmos.color;
        Gizmos.color = _cameraColor;

        Matrix4x4 tempMat = Gizmos.matrix;
        Gizmos.matrix = Matrix4x4.TRS(_player.transform.position, _player.transform.rotation, new Vector3(CAMERA_ASPECT, 1.0f, 1.0f));
        Gizmos.DrawFrustum(Vector3.zero, CAMERA_FOV, CAMERA_FAR, CAMERA_NEAR, 1.0f);
        Gizmos.color = tmpColor;
        Gizmos.matrix = tempMat;
    }

    // 高度制限を描画
    void _drawLimitAltitude()
    {
        var altPos = Vector3.zero;
        altPos.y = _player.maxAltitude;
        altPos.x = 50f;
        _drawString($"最大高度: {_player.maxAltitude}", altPos, Color.white);
        altPos.y = _player.minAltitude;
        _drawString($"最小高度: {_player.minAltitude}", altPos, Color.white);

        Color tmpColor = Gizmos.color;
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireCube(new Vector3(0f, _player.maxAltitude, 0f), ALTITUDE_PLANE);
        Gizmos.DrawLine(new Vector3(0f, _player.maxAltitude, 0f), new Vector3(0f, _player.minAltitude, 0f));
        Gizmos.DrawWireCube(new Vector3(0f, _player.minAltitude, 0f), ALTITUDE_PLANE);
        Gizmos.color = tmpColor;
    }

    // 進行ベクトルを描画
    void _drawVector()
    {
        Color tmpColor = Gizmos.color;
        Gizmos.color = new Color(1f, 0, 0, 1f);
        var to = _player.transform.position + _rigid.velocity * 2f;
        if (_rigid.velocity.magnitude < 0.1f)
        {
            to += _player.transform.forward * 2f;
        }
        GizmosExtensions.DrawArrow(_player.transform.position, to, 1f);
        Gizmos.color = tmpColor;
    }

    // Rigidbodyの情報
    void _drawRigidInfo()
    {
        _drawString($"状態:{_mode}\n速度: {_speed}\n高度: {_altitude}", _player.transform.position, Color.white);
    }

    // 画面上に文字を描画
    void _drawString(string text, Vector3 worldPos, Color? colour = null)
    {
        UnityEditor.Handles.BeginGUI();
        var restoreColor = GUI.color;

        if (colour.HasValue) GUI.color = colour.Value;
        var view = UnityEditor.SceneView.currentDrawingSceneView;
        Vector3 screenPos = view.camera.WorldToScreenPoint(worldPos);

        if (screenPos.y < 0 || screenPos.y > Screen.height || screenPos.x < 0 || screenPos.x > Screen.width || screenPos.z < 0)
        {
            GUI.color = restoreColor;
            UnityEditor.Handles.EndGUI();
            return;
        }

        Vector2 size = GUI.skin.label.CalcSize(new GUIContent(text));
        GUI.Label(new Rect(screenPos.x - (size.x / 2) + 32, -screenPos.y + view.position.height - 24, size.x, size.y), text);
        //GUI.Label(new Rect(screenPos.x - (size.x / 2), -screenPos.y + view.position.height + 4, size.x, size.y), text);
        GUI.color = restoreColor;
        UnityEditor.Handles.EndGUI();
    }
#endif
}
