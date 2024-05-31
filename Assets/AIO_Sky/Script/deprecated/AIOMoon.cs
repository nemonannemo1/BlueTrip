using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

using UnityEngine.Rendering;


[ExecuteInEditMode]
[RequireComponent(typeof(Light))]

public class AIOMoon : MonoBehaviour {

    Transform moonLight;
    Material skybox;
    bool isAIOskybox;
    [Range(0f,39f)]
    public float MoonSize;
    

private void OnEnable()    {
        moonLight = gameObject.GetComponent<Transform>();
        /*
         * string shaderName = RenderSettings.skybox.shader.name; // 1.01
        /*if (shaderName.Substring(0, 7) != "AIOsky/") isAIOskybox = false;
        if (!RenderSettings.skybox.HasProperty("_MoonPosition")) isAIOskybox = false;
        else
        isAIOskybox = true;
        */
    }
     
    // Use this for initialization
    void Start () {
        
            

    }
	
	// Update is called once per frame
	void Update () {

        if (moonLight != null && RenderSettings.skybox!=null)
        {
            if (RenderSettings.skybox.HasProperty("_MoonPosition")) RenderSettings.skybox.SetVector("_MoonPosition", Vector3.Normalize(-moonLight.transform.forward));
            if (RenderSettings.skybox.HasProperty("_moonScale")) RenderSettings.skybox.SetFloat("_moonScale", (40f-MoonSize));
        }

    }

   


}
