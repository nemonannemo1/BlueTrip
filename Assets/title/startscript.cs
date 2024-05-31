using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;

public class startscript : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform lefth;
    public Transform righth;
    public float gaget = 0f;
    private float gaged;
    
    public GameObject cuve;
    public GameObject cuve2;
    public float a;


    [SerializeField] Scene _nextScene = Scene.Main;
    [SerializeField] UnityEngine.Events.UnityEvent _goalInCallback;

    static OVRScreenFade _cameraFade;

    void Start()
    {
        gaged = 0f;
        gaged = gaget;
    }

    // Update is called once per frame
    void Update()
    {
        float left_x = lefth.transform.localPosition.x;
        float right_x = righth.transform.localPosition.x;
        float gage = Calculategage();
        float a = 0.75f * gaged;
        cuve.transform.localScale = new Vector3(a, 0.05f, 1);
        cuve2.transform.localScale = new Vector3(a, 0.05f, 1);
        if (gage <= -1)
        {
            Debug.Log("1");
            gaged += Time.deltaTime;
        }
        else
        {
            Debug.Log("-1");
            gaged -= Time.deltaTime;
        }

        if (gaged >= 3)
        {
            Debug.Log("gamestart");
            gaged = 3;
            _cameraFade = gameObject.GetComponentInChildren<OVRScreenFade>();
            _goalInCallback.Invoke();
            Next();

        }
        if(gaged <= 0)
        {
            gaged = 0;
           
        }


    }
    private float Calculategage()
    {
        float gage = lefth.localPosition.x - righth.localPosition.x;

        return gage;
    }
    
    public enum Scene
    {
        title,
        Opening,
        Tutorial,
        Main,
        Ending,
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
        SceneManager.LoadScene("Opening");
    }



}
