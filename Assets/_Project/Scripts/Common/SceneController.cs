using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
    [SerializeField] Scene _nextScene = Scene.Main;
    [SerializeField] UnityEngine.Events.UnityEvent _goalInCallback;

    static OVRScreenFade _cameraFade;

    public enum Scene
    {
        title,
        Opening,
        Tutorial,
        Main,
        Ending,
        thanksforplay,
        badending,
    }

    public void Start()
    {
    }

    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            _cameraFade = other.gameObject.GetComponentInChildren<OVRScreenFade>();
            _goalInCallback.Invoke();
            Next();
        }
    }

    // インスペクタで指定したシーンに遷移する
    public void Next()
    {
        var delay = 0f;
        if (_cameraFade != null)
        {
            _cameraFade.FadeOut();
            delay = _cameraFade.fadeTime + 0.5f;
        }
        Invoke("loadScene", delay);
    }

    void loadScene()
    {
        Debug.Log("Next");
        SceneManager.LoadScene(_nextScene.ToString());
    }
}
