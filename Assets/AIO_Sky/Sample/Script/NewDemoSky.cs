using UnityEngine;
using System.Collections;
using AIOcontrol;


public class NewDemoSky : MonoBehaviour {

    public Material[] sky = new Material[4] ;
    public float transitionSec = 10;
    // [Range(0,24)]
    static float dayTime;
    public AIOSun sample; // SkyboxLerp() isn't static , you need the class to call it;
    float oldTime;
    bool timeControl;
    bool cloudControl;
    public ReflectionProbe ball;
    public float reflectionRate = 0.1f;


    private void Awake()
    {
       // Application.targetFrameRate = 300;
    }
    // Use this for initialization
    void Start () {
        timeControl = true;
        cloudControl = true;
       // sample.cloudsAdjust = false;
        sample.ambientOverrider = true;
        //Time.fixedDeltaTime = reflectionRate;
    }
	
	// Update is called once per frame
	void Update ()
    {    
        if (reflectionRate > 0.1f)
        {
            return;
        }
        ball.RenderProbe();

    }



    public void TimeControl(bool enable)
    {
        timeControl = enable;
        /////sample.sunAnimation = enable;
        if (!timeControl)
        {
            sample.masterTimeScale = 1;
        }
    }


    public void AIOtime(float t)
    {
        if (!timeControl)
        {
            return;
        }
        sample.SetAIOTime(t);
        
    }

    public void SpeedChange(float t)
    {
        if (!timeControl)
        {
            return;
        }
        sample.masterTimeScale = t;
    }

    public void CloudsControl(bool enable)
    {
        cloudControl = enable;
        //sample.cloudsAdjust = enable;
    }

    
    public void CloudsD(float d)
    {
        if (!cloudControl)
        {
            return;
        }
        if (RenderSettings.skybox.HasProperty("_CloudsDensity")) RenderSettings.skybox.SetFloat("_CloudsDensity", d);
        // cloudsDensity = d;
    }



    public void Cloudst(float t)
    {
        if (!cloudControl)
        {
            return;
        }
            if (RenderSettings.skybox.HasProperty("_CloudsThickness")) RenderSettings.skybox.SetFloat("_CloudsThickness", t);
            // sample.cloudsThickness = t;
        
    }

    public void AmbientControl(bool enable)
    {
        sample.ambientOverrider = enable;
    }

    public void AmbientHue(float H)
    {
        sample.ambientIntensity = H;
    }

    public void AmbientBright(float B)
    {
        sample.ambientOffset = B;
    }





    public void transition(int i)
    {
        if (!sample.IsTransition)
        {
            sample.SkyboxLerp(sky[i], transitionSec);
        }
    }






}
