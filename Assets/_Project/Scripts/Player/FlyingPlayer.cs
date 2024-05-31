using UnityEngine;

public class FlyingPlayer : MonoBehaviour
{
    [Header("飛行係")]
    [CustomLabel("飛行速度")] public float forwardSpeed = 100f;
    [CustomLabel("旋回速度")] public float rotationSpeed = 30f;
    [CustomLabel("自由落下")] public float fallPower = 1f;
    [CustomLabel("急加速")] public float acceleration = 50f;
    [CustomLabel("急上昇")] public float risePower = 10f;
    [CustomLabel("急降下")] public float swoopPower = 10f;
    [CustomLabel("後手判定の距離 (m)")] public float backHandThreshold = -0.4f;

    [Header("歩行係")]
    [CustomLabel("歩行速度")] public float _walkSpeed = 2f;

    [Header("環境係")]
    [CustomLabel("最大高度")] public int maxAltitude = 100;
    [CustomLabel("最小高度")] public int minAltitude = -100;

    [Header("参照オブジェクト")]
    [SerializeField] ParticleSystem _windEffect;
    [SerializeField] ParticleSystem _accelEffect;
    [SerializeField] AudioSource _windSE;
    [SerializeField] AccelSoundEffect _accelSE;

    Rigidbody _rigid;
    CharacterController _controller;
    Transform _centerCameraAnchor;
    Transform _leftHandAnchor;
    Transform _rightHandAnchor;

    public float speed { get { return _rigid.velocity.magnitude; } }
    public float altitude { get { return transform.position.y; } }
    public float inputH { get; private set; } = 0f;
    public float inputV { get; private set; } = 0f;
    public float inputTilt { get; private set; } = 0f;
    public bool isFlyMode { get; private set; } = true;
    public bool isSwoop { get; private set; } = false;

    bool _isHitIsland = false;

    public void OnValidate()
    {
        // 最大高度と最小高度の範囲
        if (maxAltitude < 0) maxAltitude = 0;
        if (minAltitude > 0) minAltitude = 0;
    }

    public void Awake()
    {
        _rigid = GetComponent<Rigidbody>();
        _controller = GetComponent<CharacterController>();
        _centerCameraAnchor = transform.Find("OVRCameraRig/TrackingSpace/CenterEyeAnchor").transform;
        _leftHandAnchor = transform.Find("OVRCameraRig/TrackingSpace/LeftHandAnchor").transform;
        _rightHandAnchor = transform.Find("OVRCameraRig/TrackingSpace/RightHandAnchor").transform;
    }

    public void Start()
    {
        _rigid.isKinematic = false;
        _controller.enabled = false;
    }

    public void Update()
    {
        // VR,PC 両対応の入力値
        inputH = Input.GetAxis("ArrowHorizontal");
        inputV = Input.GetAxis("ArrowVertical");
        if (isFlyMode)
        {
            // VR飛行用
            inputH += _titleHands();
        }
        else
        {
            // VR歩行用
            inputH += OVRInput.Get(OVRInput.RawAxis2D.LThumbstick).x;
            inputV += OVRInput.Get(OVRInput.RawAxis2D.LThumbstick).y;
        }

        // 風の効果音
        _windSE.volume = Mathf.Clamp(speed * .5f, 0f, 1f);

        if (!isFlyMode)
        {
            _walking();
        }
    }

    public void FixedUpdate()
    {
        if (isFlyMode)
        {
            _flying();
        }
    }

    public void OnTriggerEnter(Collider collider)
    {
        if (collider.gameObject.CompareTag("Ground"))
        {
            isFlyMode = false;
            _controller.enabled = true;
            _windEffect.Stop();
            _resetRotate();
        }
        if (collider.gameObject.CompareTag("FlowerRing"))
        {
            GameManager.AddFlowerRing();
            Acceleration();
        }
        if (collider.gameObject.CompareTag("FlyPortal"))
        {
            GameManager.AddFlyPortal();
            Rise();
        }
        if (collider.gameObject.CompareTag("Island"))
        {
            var v = _rigid.velocity;
            v.x *= -2;
            v.z *= -2;
            _isHitIsland = true;
            _rigid.velocity = v;
        }
    }

    public void OnTriggerExit(Collider collider)
    {
        if (collider.gameObject.CompareTag("Ground"))
        {
            isFlyMode = true;
            _controller.enabled = false;
            _windEffect.Play();
        }
        if (collider.gameObject.CompareTag("Island"))
        {
            _isHitIsland = false;
        }
    }

    // 急加速
    public void Acceleration()
    {
        _rigid.AddForce(transform.forward * acceleration, ForceMode.Impulse);
        _accelEffect.Play();
        Instantiate(_accelSE, transform.position, Quaternion.identity, transform);
    }

    // 急降下
    public void Swoop()
    {
        _rigid.AddForce(transform.up * -swoopPower, ForceMode.Acceleration);
    }

    // 急上昇
    public void Rise()
    {
        _rigid.AddForce(transform.up * risePower, ForceMode.Impulse);
    }

    // 飛行操作
    void _flying()
    {
        // 急上昇
        if (OVRInput.GetDown(OVRInput.RawButton.LIndexTrigger) || Input.GetKeyDown(KeyCode.Z))
        {
            Rise();
        }
        // 急降下
        if (_backHands() || OVRInput.GetDown(OVRInput.RawButton.RIndexTrigger))
        {
            Swoop();
        }
        // 急加速（PCデバッグのみ
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Acceleration();
        }

        // 前進と自由落下
        Vector3 force = transform.forward * forwardSpeed + transform.up * -fallPower;
        _rigid.AddForce(force * Time.deltaTime, ForceMode.Force);
        if (!_isHitIsland) _rigid.AddForce(force * Time.deltaTime, ForceMode.Force);
        else _rigid.AddForce(transform.up * -fallPower * Time.deltaTime, ForceMode.Force);

        // 回転
        float turn = inputH * Time.deltaTime * rotationSpeed;
        Quaternion turnRotation = Quaternion.Euler(0, turn, 0);
        _rigid.MoveRotation(_rigid.rotation * turnRotation);

        // 最大高度
        if (transform.position.y > maxAltitude)
        {
            transform.position = new Vector3(transform.position.x, maxAltitude, transform.position.z);
        }
        // 最小高度
        if (transform.position.y < minAltitude)
        {
            transform.position = new Vector3(transform.position.x, minAltitude, transform.position.z);
        }
    }

    // 両手の傾き値を更新
    float _titleHands()
    {
        float deltaY = _leftHandAnchor.localPosition.y - _rightHandAnchor.localPosition.y;
        deltaY = float.IsNaN(deltaY) ? 0f : deltaY;
        deltaY = Mathf.Clamp(deltaY, -1f, 1f);
        inputTilt += (deltaY - inputTilt) * 0.1f;
        return inputTilt;
    }

    // 両手が後ろにあるか
    bool _backHands()
    {
        float _leftDot = Vector3.Dot(_centerCameraAnchor.forward, _leftHandAnchor.position - _centerCameraAnchor.position);
        float _rightDot = Vector3.Dot(_centerCameraAnchor.forward, _rightHandAnchor.position - _centerCameraAnchor.position);
        float _bothDot = (_leftDot + _rightDot) / 2.90f;
        isSwoop = _bothDot < backHandThreshold;
        return isSwoop;
    }

    // 歩行操作
    void _walking()
    {
        Vector3 direction = transform.forward * inputV;
        Vector3 velocity = Vector3.zero;
        velocity.x = direction.x * _walkSpeed;
        velocity.z = direction.z * _walkSpeed;
        _controller.Move(velocity * Time.deltaTime);
        transform.Rotate(0, inputH, 0);
    }

    // ピッチとロールをリセット
    void _resetRotate()
    {
        Vector3 rotation = transform.rotation.eulerAngles;
        rotation.x = 0f;
        rotation.z = 0f;
        transform.rotation = Quaternion.Euler(rotation);
    }
}
