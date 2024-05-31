using System.Collections;
using System.Collections.Generic;
using UnityEngine;



namespace UnityStandardAssets.ImageEffects
{
    [ExecuteInEditMode]
    public class AIOSunShaftsHelper : MonoBehaviour
    {
        public Transform helperTranform;
        public Camera activeCamera;
        public Light sunLight;
        public bool sunShaftsInastalled;
        SunShafts ssComponent;
        [HideInInspector]
        public int quality = 0;
        public float distanceFalloff = .5f;
        public float blurSize = 5;
        public float intensity = 1.5f;

        private bool ssComDistory = true;

        // Use this for initialization

        private void OnEnable()
        {
            
            sunShaftsInastalled = true;
            helperTranform = GetComponent<Transform>();
            initSS();

        }

        private void OnDisable()
        {
            if (ssComponent != null)
            {                
                ssComponent.enabled = false;
            }
            
        }

        private void Reset()
        {
            if (!Application.isPlaying)
            {
                Debug.Log("helper Reset called");                
            }
        }

        void Start()
        {
            Debug.Log("helper start called");
            

        }

        // Update is called once per frame
        void Update()
        {
            helperTranform.position = activeCamera.transform.position - sunLight.transform.forward * activeCamera.nearClipPlane * 2;
            if (ssComponent!=null)
            {
                //ssComponent.SunShaftsResolution = (SunShafts.SunShaftsResolution)Enum.ToObject(typeof(SunShafts.SunShaftsResolution), Quality);
                ssComponent.maxRadius = 1.0f - distanceFalloff; // DistanceFalloff;
                ssComponent.sunShaftBlurRadius = blurSize;
                ssComponent.sunShaftIntensity = intensity;
                //sunshaft color WIP
            }
        }


        private void OnDestroy()
        {
            if (!Application.isPlaying)
            {
                if (ssComponent != null && !ssComDistory)
                {
                    DestroyImmediate(ssComponent);
                    ssComDistory = true;
                }
            }
        }


        void initSS()
        {
            Debug.Log("helper initSS");
            Debug.Log(activeCamera);
            //yield return new WaitForSeconds(1f);
            if (activeCamera != null)
            {
                //ssComponent = activeCamera.GetComponent("UnityStandardAssets.ImageEffects.SunShafts, Assembly-CSharp-firstpass");
                ssComponent = activeCamera.GetComponent<SunShafts>();
                if (ssComponent == null)
                {
                    ssComponent = activeCamera.gameObject.AddComponent<SunShafts>();
                    SunShafts com = ssComponent as SunShafts;
                    com.simpleClearShader = Shader.Find("Hidden/SimpleClear");
                    com.sunShaftsShader = Shader.Find("Hidden/SunShaftsComposite");
                    com.sunTransform = helperTranform;
                    bool test = com.CheckResources();
                    com.enabled = true;
                    ssComDistory = false;
                    Debug.Log("SS created"+","+ test);
                    //add effect
                    // ssComponent = activeCamera.gameObject.AddComponent(System.Type.GetType("UnityStandardAssets.ImageEffects.SunShafts, Assembly-CSharp-firstpass")); //add effect
                }
                else
                {
                    ssComponent.enabled = true;
                }


            }
        }        

    }
}
