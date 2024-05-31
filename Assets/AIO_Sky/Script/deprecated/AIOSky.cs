using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine.Rendering;





/// <summary>
/// version 1.2
/// fog control
/// 
/// version 1.1
/// 
/// add time control api, fix change skybox in editor bugs(need to update old data stored)
/// </summary>


namespace AIOcontrol
{
    [ExecuteInEditMode]

    public class AIOSky : MonoBehaviour {

        bool isAIOskyBox;
        [Header("AIO Sky v1.2", order = 0)]
        //v1.2
        public Camera aioCamera;
        Camera oldCamera; // for camera change
        //v1.2

        [Space(10, order = 1)]
        [Header("Sun/Moon", order = 2)]
        //public bool intensityOverride = true;
        public Light sunLight;
        public Light moonLight;
        [Range(0.025f, 1f)]
        public float moonScale = 0.1f;
        

        [Space(10)]
        [Header("Animation/Only affect Runtime")]
        [Range(-10f, 10f)]
        public float masterTimeScale = 1;
        //sun light animation
        public bool sunAnimation = false;
        [Range(1,1440)]
        public int minPerDay = 1;
        float sunRotateSpeed = 0.1f;
        

        //v1.2
        public float sunIntensity; //wip multiply intensity presented
        [Range(0f,24f)]
        public float sunHour;
        [HideInInspector]
        public float sunAltitudeAngle;
        [HideInInspector]
        [Range(0,360)]
        public float sunBearingAngle;
        //v1.2


        [Space(10)]
        [Header("Clouds")]
        public bool cloudsAdjust = false;
        [Range(-1f, 1f)]
        public float cloudsDensity = 0f;
        [Range(0.0001f, 1f)]
        public float cloudsThickness = .5f;
        float oldCloudDesity;
        float oldCloudThickness;

        //v1.2
        [Range(0,1)]
        public float domeCurved = 0.3f;
        [Range(0.5f,10)] //+ 0.5
        public float cloudsScale = 1.8f;
        [Range (0,1)] //*2 pi
        public float cloudsRotation = 0;
        [Range(0, 1)]
        public float flowSpeed;
        [Range(0, 1)]
        public float cloudSpeed;
       
        float oldDomeCurved, oldCloudsScale, oldCloudsRotation,oldCloudSpeed,oldFlowSpeed;
        //v1.2



        // private
        [HideInInspector]
        public Material skyBoxEditor;
        static Material skyBoxRuntime;
        static Transform sunTransform, moonTransform;
        float skyboxTime1, skyboxTime2;
        Vector2 skyboxPan1, skyboxPan2;
        Vector2 skyboxDir1 = new Vector2(1, 1), skyboxDir2 = new Vector2(1, 1);
        float  dayRange, setRange = 0.2f, nightRange = -0.2f;



        //ambient setting
        Color daySky, setSky, nightSky, dayAtm, setAtm, nightAtm, groundColor; //v1.2 change color32 to color
        bool setAmbientMode=false;
        AmbientMode oldAMode;
        Color amb1, amb2, amb3,amb4;
        

        [Space(10)]
        [Header("Ambient/Environment Lighting Overrider")]
        //[HideInInspector]
        public bool ambientOverrider = false;
        //[HideInInspector]
        [Range(0f, 1f)]
        public float ambientIntensity = 0.5f;
        //[HideInInspector]
        [Range(0f, 1f)]
        public float ambientOffset = 0.2f;

        // When IsTransition, don't touch the skyruntime
        private bool isTransition;
        public bool IsTransition
        {
            get
            {
                return isTransition;
            }
        }

        //v1.2
        [Space(10)]
        [Header("Fog Control")]
        public bool fogControl = false;
        [Range(0f,1f)]
        public float fogAmbientWeighting = 0.5f;
        [Space(10)]
        [Range(0f, 1f)]
        public float fogLevel=.1f;
        public Color aioFogColor=Color.gray;
        
        [Range(-0.5f, 0.85f)]
        public float groundLevel;
        Color aioGroundColor;

        bool setFog = false;
        Color oldFogColor, oldGroundColor,oldAioFog;
        float oldGroundLevel, oldFogLevel;

        [Space(10)]
        [Header("Sun Shafts")]
        public bool sunShaftsEnable = false;
        //[Range(0,2)]
       // public int ssQuality = 0;
        [Range(0.1f, 1f)]
        public float ssDistanceFalloff = .75f;
        [Range(1,10)]
        public float ssBlurSize = 2.5f;
        [Range(0, 10)]
        public float ssIntensity = 1.15f;
        GameObject SsHelperGO;
        AIOSunShaftsHelper aioSSHelper;
        

        //WIP some var only need in editor, try to remove it as runtime?
        //v1.2

        //ambient lighting
        Color cTop, cSide, cBottom;


        //Gizmos
        [Space(10)]
        [Header("Sun Gizmos")]
        public bool drawGizmos = true;
        public float size = 10;
        public Color textColor = Color.blue;
        public Color iconColor = Color.red;


        private void OnEnable()
        {
            //v1.2
            // change camera will affect sunshafts & other screen effect
            if (aioCamera == null)
            {
                aioCamera = Camera.main;
                oldCamera = aioCamera;
                //v1.2
            }
            // hack between runtime & editor setting
            /*
            if (skyBoxEditor != null)
            {
                //Debug.Log("old skyboxeditor used");
                RenderSettings.skybox = skyBoxEditor;
            }
            */
            //

            if (!Application.isPlaying)
            {
                //Debug.Log("Editor awake");
               
                InitSkybox();
                if (!isAIOskyBox)
                {
#if UNITY_EDITOR
                    EditorUtility.DisplayDialog("SkyBox must be AIO material!", "Set AIO SkyBox in Lighting window>Environment>Skybox", "Close");
                    //error message
#endif
                    return;
                }
                //moonScale = 1 / RenderSettings.skybox.GetFloat("_moonScale");
                return;
            }
            else
            {
                //Debug.Log("Runtime awake");

                InitSkybox();

                if (!isAIOskyBox)
                {
                    return;
                }


                //Runtime Light control
                if (sunLight != null)
                {
                    sunIntensity = sunLight.intensity;
                    sunTransform = sunLight.GetComponent<Transform>();
                }

                //setup the clouds for runtime
                if (RenderSettings.skybox.HasProperty("_timeScale")) skyboxTime1 = RenderSettings.skybox.GetFloat("_timeScale");
                if (RenderSettings.skybox.HasProperty("_DistortionTime")) skyboxTime2 = RenderSettings.skybox.GetFloat("_DistortionTime");
                if (RenderSettings.skybox.HasProperty("_timeScale")) RenderSettings.skybox.SetFloat("_timeScale", 0f);
                if (RenderSettings.skybox.HasProperty("_DistortionTime")) RenderSettings.skybox.SetFloat("_DistortionTime", 0f);
                if (RenderSettings.skybox.HasProperty("_CloudsPan")) skyboxPan1 = RenderSettings.skybox.GetVector("_CloudsPan");
                //skyboxPan2 = RenderSettings.skybox.GetVector("_DistortionPan");

                //other
                //moonScale = 1 / RenderSettings.skybox.GetFloat("_moonScale");
                isTransition = false;


            }

        }

        private void Start()
        {
            
            if (Application.isPlaying)
            {
                Material skyBox = RenderSettings.skybox;
                skyBoxRuntime = new Material(skyBox)
                {
                    name = skyBox.name + "_Runtime"
                };
                RenderSettings.skybox = skyBoxRuntime;                
            }
            


        }


        // Update is called once per frame
        private void LateUpdate() {
            //v1.2
            
            if (sunLight != null)
            {
                setSun();                    
            }
            //v1.2


            if (!isAIOskyBox)
            {
                //error
                InitSkybox();
                return;
            }
            
            if (!Application.isPlaying)
            {
                
               
                /* //remove v1.3
                if (RenderSettings.skybox != skyBoxRuntime)
                {
                    //Debug.Log("switch skybox");
                    cloudsAdjust = false;
                    InitSkybox();

                    return;
                }
                *///remove v1.3 
                
                /*//v1.2 editor light intensity overrider & restore before render gui
                if ((sunLight != null) && intensityOverride)
                {
                    usersunIntensity = sunLight.intensity;
                    //sunlight only animat in Runtime
                    Vector3 lightForward = Vector3.Normalize(sunTransform.forward);
                    sunLight.intensity = Mathf.SmoothStep(sunIntensity, 0, 2 * (Mathf.Clamp(lightForward.y, nightRange, setRange) - nightRange) / (setRange - nightRange));
                }
                //v1.2 */

                AIOupdate();
                
                return;
            }
            else
           
                {
                    //Runtime
                    if (sunLight != null)
                {
                    Vector3 lightForward = Vector3.Normalize(sunTransform.forward);
                    sunLight.intensity = Mathf.SmoothStep(sunIntensity, 0, 2 * (Mathf.Clamp(lightForward.y, nightRange, setRange) - nightRange) / (setRange - nightRange));
                    if (sunAnimation)
                    {
                        SetAIOTime(sunHour);
                        sunLight.transform.Rotate(Vector3.right, sunRotateSpeed * Time.deltaTime * masterTimeScale);
                        sunHour = ((360 - (90 + SignedAngle(ABinterSecDir(Vector3.up, sunTransform.right), sunTransform.forward, -sunTransform.right))) % 360) / 15;
                        // rot.x += sunLightRotateSpeed * Time.deltaTime * masterTimeScale;
                        // //Debug.Log(rot.x);
                        //sunLight.transform.Rotate(rot);              
                    }
                }
                //Runtime
                if (RenderSettings.skybox != skyBoxRuntime)
                {
                    //Debug.Log("switch skybox");

                    InitSkybox();

                    return;
                }

               

                //clouds anmaition for Runtime
                skyboxPan1 += Time.deltaTime * skyboxTime1 * skyboxDir1 * masterTimeScale;
                skyboxPan2 += Time.deltaTime * skyboxTime2 * skyboxDir2 * masterTimeScale;

                skyboxPan2 = new Vector2(skyboxPan2.x % 1, skyboxPan2.y % 1);

                RenderSettings.skybox.SetVector("_CloudsPan", skyboxPan1);
                RenderSettings.skybox.SetVector("_DistortionPan", skyboxPan2);

                //oldCloudDesity = RenderSettings.skybox.GetFloat("_CloudsDensity");
                //oldCloudThickness = RenderSettings.skybox.GetFloat("_CloudsThickness");

                AIOupdate();


            }
        }





        private void InitSkybox()
        {
#if UNITY_5_6_OR_NEWER
            sunLight = RenderSettings.sun;      //maynot compatible in old version
#endif

            if (sunLight != null)
            {
                sunTransform = sunLight.GetComponent<Transform>();
                //v1.2
                sunIntensity = sunLight.intensity;
                sunHour = ((360 - (90 + SignedAngle(ABinterSecDir(Vector3.up, sunTransform.right), sunTransform.forward, -sunTransform.right))) % 360) / 15;
                sunAltitudeAngle = sunTransform.eulerAngles.z; //wip
                sunBearingAngle = Vector3.Angle(ABinterSecDir(Vector3.up, sunTransform.right), new Vector3(0,0,1)); //east //wip  
                //v1.2
            }
            else
            {
                sunLight = FindObjectOfType<Light>();
                sunTransform = sunLight.GetComponent<Transform>();
            }

            //moonScale = 1 / RenderSettings.skybox.GetFloat("_moonScale");
            if (moonLight != null)
            {
                moonTransform = moonLight.GetComponent<Transform>();
                if (RenderSettings.skybox.HasProperty("_MoonPosition")) RenderSettings.skybox.SetVector("_MoonPosition", Vector3.Normalize(-moonLight.transform.forward));
            }



            //check skybox material is AIOsky
            if (RenderSettings.skybox == null)
            {
                //Debug.Log("null");
                isAIOskyBox = false;

                //Debug.Log("The skybox must be set to AIO material!!!");
                //error massage
                return;
            }

            string shaderName = RenderSettings.skybox.shader.name; // 1.01
            if (shaderName.Substring(0, 7) != "AIOsky/") //1.1
            //if (RenderSettings.skybox.shader != Shader.Find("AIOsky/Std01"))
            {
                //Debug.Log("wrong shader");
                isAIOskyBox = false;

                //Debug.Log("The skybox must be set to AIO material!!!");
                //error massage
                return;
            }
            else
            {
                isAIOskyBox = true;
            }

            storeOldCloudsSetting();
            getClouds();


            ///
            if (RenderSettings.skybox.HasProperty("_DayRange")) dayRange = RenderSettings.skybox.GetFloat("_DayRange");
            if (RenderSettings.skybox.HasProperty("_setRange")) setRange = RenderSettings.skybox.GetFloat("_setRange");
            if (RenderSettings.skybox.HasProperty("_nightRange")) nightRange = RenderSettings.skybox.GetFloat("_nightRange");

            //fix  (ambient)
            if (RenderSettings.skybox.HasProperty("_DaySky")) daySky = RenderSettings.skybox.GetColor("_DaySky");
            if (RenderSettings.skybox.HasProperty("_SunSetSky")) setSky = RenderSettings.skybox.GetColor("_SunSetSky");
            if (RenderSettings.skybox.HasProperty("_NightSky")) nightSky = RenderSettings.skybox.GetColor("_NightSky");
            if (RenderSettings.skybox.HasProperty("_DayAtmosphere")) dayAtm = RenderSettings.skybox.GetColor("_DayAtmosphere");
            if (RenderSettings.skybox.HasProperty("_SunSetAtmosphere")) setAtm = RenderSettings.skybox.GetColor("_SunSetAtmosphere");
            if (RenderSettings.skybox.HasProperty("_NightAtmosphere")) nightAtm = RenderSettings.skybox.GetColor("_NightAtmosphere");
            if (RenderSettings.skybox.HasProperty("_GroundColor")) groundColor = RenderSettings.skybox.GetColor("_GroundColor");
            //oldAMode = RenderSettings.ambientMode;

            //v1.2 fog
            oldFogColor = RenderSettings.fogColor;
            if (RenderSettings.skybox.HasProperty("_FogColor")) oldAioFog = RenderSettings.skybox.GetColor("_FogColor");
            if (RenderSettings.skybox.HasProperty("_GroundColor")) oldGroundColor = RenderSettings.skybox.GetColor("_GroundColor");
            if (RenderSettings.skybox.HasProperty("_FogLevel")) oldFogLevel = RenderSettings.skybox.GetFloat("_FogLevel");
            if (RenderSettings.skybox.HasProperty("_GroundLevel")) oldGroundLevel = RenderSettings.skybox.GetFloat("_GroundLevel");








            // oldCloudDesity = RenderSettings.skybox.GetFloat("_CloudsDensity");
            //oldCloudThickness = RenderSettings.skybox.GetFloat("_CloudsThickness");

            //new Runtime material
            if (Application.isPlaying)
            {
                skyBoxEditor = RenderSettings.skybox;
                //Debug.Log(skyBoxEditor.name+" is oringin sky");
                skyBoxRuntime = new Material(skyBoxEditor)
                {
                    name = skyBoxEditor.name + "_Runtime"
                };
                RenderSettings.skybox = skyBoxRuntime;
            }
        }


        private void AIOupdate()
        {
            if (moonLight != null)
            {
                if (RenderSettings.skybox.HasProperty("_MoonPosition")) RenderSettings.skybox.SetVector("_MoonPosition", Vector3.Normalize(-moonLight.transform.forward));
                if (RenderSettings.skybox.HasProperty("_moonScale")) RenderSettings.skybox.SetFloat("_moonScale", 1 / moonScale);
            }

            //clouds
            if (cloudsAdjust)
            {
                setClouds();

            }
            else
            {
                restoreOldCloudsSetting();

            }

            //ambient fix
            if (ambientOverrider)
            {
                if (!setAmbientMode)
                {
                    oldAMode = RenderSettings.ambientMode;
                    amb1 = RenderSettings.ambientEquatorColor;
                    amb2 = RenderSettings.ambientGroundColor;
                    amb3 = RenderSettings.ambientLight;
                    amb4 = RenderSettings.ambientSkyColor;
                }
                setAmbientMode = true;
                RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Trilight;
                UpDateAmbient();
                //DynamicGI.UpdateEnvironment();   //v1.2 alreadly inDateAmbientLUp
            }
            else
            {
                if (setAmbientMode)
                {
                    RenderSettings.ambientMode = oldAMode;
                    RenderSettings.ambientEquatorColor = amb1;
                    RenderSettings.ambientGroundColor = amb2;
                    RenderSettings.ambientLight = amb3;
                    RenderSettings.ambientSkyColor = amb4;
                    DynamicGI.UpdateEnvironment();
                    setAmbientMode = false;
                }
            }
            //v1.2
            //FogControl
            if (fogControl)
            {
                if (!setFog)
                {
                    //RenderSettings.fogColor = aioFogColor*fogAmbientWeighting; //WIP
                    oldFogColor = RenderSettings.fogColor;
                    if (RenderSettings.skybox.HasProperty("_FogColor")) oldAioFog = RenderSettings.skybox.GetColor("_FogColor");
                    if (RenderSettings.skybox.HasProperty("_GroundColor")) oldGroundColor = RenderSettings.skybox.GetColor("_GroundColor");
                    if (RenderSettings.skybox.HasProperty("_FogLevel")) oldFogLevel = RenderSettings.skybox.GetFloat("_FogLevel");
                    if (RenderSettings.skybox.HasProperty("_GroundLevel")) oldGroundLevel = RenderSettings.skybox.GetFloat("_GroundLevel");
                    setFog = true;
                }
                UpDateFog();
            }
            else
            {
                if (setFog)
                {
                    //restore fog color;
                    RenderSettings.fogColor = oldFogColor;
                    if (RenderSettings.skybox.HasProperty("_FogColor")) RenderSettings.skybox.SetColor("_FogColor", oldAioFog);
                    if (RenderSettings.skybox.HasProperty("_GroundColor")) RenderSettings.skybox.SetColor("_GroundColor", oldGroundColor);
                    if (RenderSettings.skybox.HasProperty("_FogLevel")) RenderSettings.skybox.SetFloat("_FogLevel", oldFogLevel);
                    if (RenderSettings.skybox.HasProperty("_GroundLevel")) RenderSettings.skybox.SetFloat("_GroundLevel", oldGroundLevel);
                    //RenderSettings.fogColor = aioFogColor;
                    DynamicGI.UpdateEnvironment();
                    setFog = false;
                }
            }

            //sunshaft controll
            if (sunShaftsEnable)
            {
                if (aioSSHelper != null)
                {
                    //aioSSHelper.Quality = ssQuality;
                    aioSSHelper.distanceFalloff = ssDistanceFalloff;
                    aioSSHelper.blurSize = ssBlurSize;
                    aioSSHelper.intensity = ssIntensity;
                    
                }
            }
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {

                if (sunShaftsEnable)
                {
                    if (SsHelperGO == null)
                    {
                        if (!CreateSSHelper())
                        {
                            sunShaftsEnable = false; //no sunshaft effect
                                                     //displace install imageeffect massage
                        }
                        else
                        {
                            aioSSHelper.enabled = true;
                        }
                    }
                    else
                    {
                        if (aioSSHelper.activeCamera != aioCamera)
                        {
                            DestroyImmediate(aioSSHelper.gameObject);
                            CreateSSHelper();
                            aioSSHelper.enabled = true;
                        }
                        else
                        {
                            aioSSHelper.enabled = true;
                        }

                        //check camera change?
                        //effect enable ?

                        //update ss effect
                    }
                }
                else
                {
                    //disable ss
                    if (aioSSHelper != null)
                    {
                        aioSSHelper.enabled = false;
                        /*
                        if (aioSSHelper.sunShaftsInastalled)
                        {
                            aioSSHelper.enabled = false;
                            //disable sunshafe effect
                        }*/
                    }
                }
            }
#endif  //*/
            
        }


        private void OnApplicationQuit()
        {

            OnDisable();
            //Debug.Log("quit");
        }


        private void OnDisable()
        {
            //Debug.Log("disable");
            //Debug.Log(skyBoxEditor.name);
            //RenderSettings.skybox = skyBoxEditor;
            //v1.2
            if (sunLight != null)
            {
                sunLight.intensity = sunIntensity;
            }
            //v1.2
        }


        public float Remap(float minIn, float maxIn, float minOut, float maxOut, float valueIn)
        {
            return minOut + (maxOut - minOut) * ((valueIn - minIn) / (maxIn - minIn));
        }


       public void SkyboxLerp(Material mat, float t)
        {
            if (mat.shader != skyBoxRuntime.shader)//only same shader can lerp
            {
                Debug.Log("Only The same shader material can lerp!!");
                return;
            }
            StartCoroutine(SwitchBG( mat, t));
        }


        // transition between skybox in second
        public IEnumerator SwitchBG(Material mat, float t)
        {
            if(mat.shader != skyBoxRuntime.shader)//only same shader can lerp
            {
                yield break;
            }

            isTransition = true;
            if (t <= 0)
            {
                t = 1 / 60;
            }

            float StartTime = Time.time;
            float localTime = 0;
            float sourceTime1 = skyboxTime1;
            float sourceTime2 = skyboxTime2;
            float targetTime1 = mat.GetFloat("_timeScale");
            float targetTime2 = mat.GetFloat("_DistortionTime");

            Material matTemp = new Material(mat);

            // Match the differen can't lerp
            matTemp.SetFloat("_timeScale", 0f);
            matTemp.SetFloat("_DistortionTime", 0f);
            matTemp.SetVector("_MoonPosition", Vector3.Normalize(-moonLight.transform.forward));
            matTemp.SetFloat("_moonScale", 1 / moonScale);
            //matTemp.SetVector("_CloudsPan", skyboxPan1);
            //matTemp.SetVector("_DistortionPan", skyboxPan2);

            do
            {
                float gamma = 1f/ 0.2f;
                skyboxTime1 = Mathf.Lerp(sourceTime1, targetTime1, Mathf.Pow(localTime, gamma)*.5f);
                skyboxTime2 = Mathf.Lerp(sourceTime2, targetTime2, Mathf.Pow(localTime, gamma)*.5f);
                RenderSettings.skybox.Lerp(skyBoxRuntime, matTemp, Mathf.Pow(localTime,gamma)*.5f);


                setRange = RenderSettings.skybox.GetFloat("_setRange");
                nightRange = RenderSettings.skybox.GetFloat("_nightRange");

                storeOldCloudsSetting();
                

                //fix  (ambient)
                daySky = RenderSettings.skybox.GetColor("_DaySky");
                setSky = RenderSettings.skybox.GetColor("_SunSetSky");
                nightSky = RenderSettings.skybox.GetColor("_NightSky");
                dayAtm = RenderSettings.skybox.GetColor("_DayAtmosphere");
                setAtm = RenderSettings.skybox.GetColor("_SunSetAtmosphere");
                nightAtm = RenderSettings.skybox.GetColor("_NightAtmosphere");
                groundColor = RenderSettings.skybox.GetColor("_GroundColor");
               // Debug.Log(localTime);

                yield return null;
                localTime = (Time.time - StartTime) / t;

            }
            while (localTime < 1);
            Debug.Log("to " + mat.name + " Done!");
            isTransition = false;

            //Debug.Log("done!");

        }





        //Ambient fix from shader
        private void UpDateAmbient()
        {
            if (sunTransform == null)
            {
                return;
            }

            Vector3 ase_worldlightDir = Vector3.Normalize(-sunTransform.forward);

            ///*
            cTop = Color.Lerp(Color.Lerp(setSky, daySky, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (dayRange - setRange)), 0f, 1f)), nightSky, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (nightRange - setRange)), 0f, 1f));
            cSide = Color.Lerp(Color.Lerp(setAtm, dayAtm, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (dayRange - setRange)), 0f, 1f)), nightAtm, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (nightRange - setRange)), 0f, 1f));
            cBottom = groundColor;

            //*/

            //RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Trilight;
            RenderSettings.ambientSkyColor = cTop * ambientIntensity + new Color(ambientOffset, ambientOffset, ambientOffset);
            RenderSettings.ambientEquatorColor = cSide * ambientIntensity + new Color(ambientOffset, ambientOffset, ambientOffset);
            RenderSettings.ambientGroundColor = cBottom * ambientIntensity + new Color(ambientOffset, ambientOffset, ambientOffset);
            DynamicGI.UpdateEnvironment();
        }


        private void UpDateFog() //v1.2
        {
            Vector3 ase_worldlightDir = Vector3.Normalize(-sunTransform.forward);
            Color updateFogColor= ((1 - fogAmbientWeighting) * aioFogColor + fogAmbientWeighting * Color.Lerp(Color.Lerp(setAtm, dayAtm, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (dayRange - setRange)), 0f, 1f)), nightAtm, Mathf.Clamp((0f + (ase_worldlightDir.y - setRange) * (1f - 0f) / (nightRange - setRange)), 0f, 1f)))/2; 

            RenderSettings.fogColor = updateFogColor;
            if (RenderSettings.skybox.HasProperty("_FogColor")) RenderSettings.skybox.SetColor("_FogColor", updateFogColor);
            if (RenderSettings.skybox.HasProperty("_GroundColor")) RenderSettings.skybox.SetColor("_GroundColor", updateFogColor);
            if (RenderSettings.skybox.HasProperty("_FogLevel")) RenderSettings.skybox.SetFloat("_FogLevel", fogLevel);
            if (RenderSettings.skybox.HasProperty("_GroundLevel")) RenderSettings.skybox.SetFloat("_GroundLevel", groundLevel);
            DynamicGI.UpdateEnvironment();
        }


#if UNITY_EDITOR
        private void OnDrawGizmos()
        {
            /*//v1.2 restore light intensity
            if ((sunLight != null) && intensityOverride)
            {
                 sunLight.intensity = usersunIntensity;
                
            }
            //*/



            //Camera cam = Camera.current;
            var view = UnityEditor.SceneView.currentDrawingSceneView;
            Camera cam = view.camera; //v1.1
            if (sunTransform == null)
            {
                return;
            }
            Vector3 east = ABinterSecDir(Vector3.up, sunTransform.right);
            if (cam != null && drawGizmos)
            {
                float D = 1000; // cam.farClipPlane-100;
                Gizmos.color = iconColor;
                Vector3 lastPos,newPos;// = east;
                lastPos = east * D + cam.transform.position; //v1.1
                for (int i = 0; i <= 12; i++)
                {                    
                    int Hour = i + 6;                    
                    newPos = Quaternion.AngleAxis(15 * i, sunTransform.right) * east*D + cam.transform.position;//v1.1
                    Gizmos.DrawLine(lastPos, newPos);
                    Gizmos.DrawWireSphere(newPos, size);
                    DrawString(Hour.ToString() + ":00", newPos, textColor);
                    lastPos = newPos;
                }

                //Debug.Log((360-(90+SignedAngle(ABinterSecDir(groundUP, sunTransform.right), sunLight.forward,- sunLight.right)))%360);// working
                //Debug.Log(gameTime());
            }




        }
#endif

        // get runtime material for addition control

        static public Material GetRuntimeMat()
        {
            return skyBoxRuntime;
        }


        static public float GetAioTime()
        {
            if (sunTransform == null)
            {
                return -1f;
            }

            return ((360 - (90 + SignedAngle(ABinterSecDir(Vector3.up, sunTransform.right), sunTransform.forward, -sunTransform.right))) % 360) / 15;
        }

        //static 
        public void SetAIOTime(float t)
        {
            sunHour = t;
            t = (t%24)*15;
            if (sunTransform != null)
            {
                //Quaternion rotation = new Quaternion();
                //rotation.SetLookRotation(ABinterSecDir(Vector3.up, sunTransform.right),Vector3.up);
                //sunTransform.rotation = rotation;
                //sunTransform.LookAt(ABinterSecDir(Vector3.up, sunTransform.right)+sunTransform.position, sunTransform.forward);
               // Debug.Log(GetAioTime());
                sunTransform.Rotate(Vector3.right, -GetAioTime()*15);
                sunTransform.Rotate(Vector3.right, t);
               // Debug.Log(GetAioTime());
                //sunLight.transform.Rotate(Vector3.right, t);
                //ABinterSecDir(Vector3.up, sunTransform.right) * Quaternion.AngleAxis(t, sunTransform.right);
                //sunLight.transform.LookAt(ABinterSecDir(Vector3.up, sunTransform.right), sunTransform.right);
            }
        }

       


        static Vector3 ABinterSecDir(Vector3 A, Vector3 B)
        {
            Vector3 east;
            east = Vector3.Normalize(Vector3.Cross(A, B));
            // if AB is parallel (perpendicular )
            if (east == new Vector3(0, 0, 0))
            {
                east = Vector3.forward;
            }
            return east;
        }

        static float SignedAngle(Vector3 A, Vector3 B, Vector3 planeUp)
        {
            //n would be the normal of your plane to determine what you would call "clockwise/counterclockwise"
            // angle in [0,180]
            float angle = Vector3.Angle(A, B);
            float sign = Mathf.Sign(Vector3.Dot(planeUp, Vector3.Cross(A, B)));

            // angle in [-179,180]
            float signed_angle = angle * sign;

            // angle in [0,360] (not used but included here for completeness)
            //float angle360 =  (signed_angle + 180) % 360;

            return signed_angle;
        }


        /// <summary>
        /// 1.1 Code Start
        /// </summary>
        /// <param name="text"></param>
        /// <param name="worldPos"></param>
        /// <param name="colour"></param>

        void Flare()
        {
            //wip
        }


        float GetClouds(Vector3 P)
        {
            // from matrial information simple one pixel is there clouds affect len flare //wip

            return 0f;
        }

        /// <summary>
        /// 1.1 Code End
        /// </summary>
        /// <param name="text"></param>
        /// <param name="worldPos"></param>
        /// <param name="colour"></param>
           


#if UNITY_EDITOR

        //https://gist.github.com/Arakade/9dd844c2f9c10e97e3d0
        static void DrawString(string text, Vector3 worldPos, Color? colour = null)
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

        //v1.2

        bool CreateSSHelper()
        {
            
            var go = aioCamera.GetComponent<Transform>().Find("AioSunShaftsHelper");
            if (go==null)                
            {
                Debug.Log("no sshelpergo"); //wip
                SsHelperGO = new GameObject();
                SsHelperGO.name = "AioSunShaftsHelper";
                SsHelperGO.transform.SetParent(aioCamera.transform);
                aioSSHelper =  SsHelperGO.AddComponent<AIOSunShaftsHelper>() as AIOSunShaftsHelper;
                aioSSHelper.enabled = false;
                aioSSHelper.activeCamera = aioCamera;
                aioSSHelper.sunLight = sunLight;
                

                return aioSSHelper.sunShaftsInastalled; 
            }
            else
            {                
                aioSSHelper = go.GetComponent<AIOSunShaftsHelper>();
                return aioSSHelper.sunShaftsInastalled;
            }

        }

        private void storeOldCloudsSetting()
        {
            oldCloudDesity = RenderSettings.skybox.GetFloat("_CloudsDensity");
            oldCloudThickness = RenderSettings.skybox.GetFloat("_CloudsThickness");
            //v1.2
            oldDomeCurved = RenderSettings.skybox.GetFloat("_DomeCurved");
            oldCloudsScale = RenderSettings.skybox.GetFloat("_CloudsScale");
            oldCloudsRotation = RenderSettings.skybox.GetFloat("_CloudsRotation")/(2*Mathf.PI);
            oldCloudSpeed = RenderSettings.skybox.GetFloat("_timeScale")*20;
            oldFlowSpeed = RenderSettings.skybox.GetFloat("_DistortionTime")*5;
        }

        private void restoreOldCloudsSetting()
        {
            RenderSettings.skybox.SetFloat("_CloudsDensity", oldCloudDesity);
            RenderSettings.skybox.SetFloat("_CloudsThickness", oldCloudThickness);
            RenderSettings.skybox.SetFloat("_DomeCurved", oldDomeCurved);
            RenderSettings.skybox.SetFloat("_CloudsScale", oldCloudsScale);
            RenderSettings.skybox.SetFloat("_CloudsRotation", oldCloudsRotation * Mathf.PI*2);
            RenderSettings.skybox.SetFloat("_timeScale", oldCloudSpeed/20);
            RenderSettings.skybox.SetFloat("_DistortionTime", oldFlowSpeed/5);
        }

        private void setClouds()
        {
            if (RenderSettings.skybox.HasProperty("_CloudsDensity")) RenderSettings.skybox.SetFloat("_CloudsDensity", cloudsDensity);
            if (RenderSettings.skybox.HasProperty("_CloudsThickness")) RenderSettings.skybox.SetFloat("_CloudsThickness", cloudsThickness);
            if (RenderSettings.skybox.HasProperty("_DomeCurved")) RenderSettings.skybox.SetFloat("_DomeCurved", domeCurved);
            if (RenderSettings.skybox.HasProperty("_CloudsScale")) RenderSettings.skybox.SetFloat("_CloudsScale", cloudsScale);
            if (RenderSettings.skybox.HasProperty("_CloudsRotation")) RenderSettings.skybox.SetFloat("_CloudsRotation", cloudsRotation*Mathf.PI*2);
            if (RenderSettings.skybox.HasProperty("_timeScale")) RenderSettings.skybox.SetFloat("_timeScale", cloudSpeed/20);
            if (RenderSettings.skybox.HasProperty("_DistortionTime")) RenderSettings.skybox.SetFloat("_DistortionTime", flowSpeed/5);

        }

        private void getClouds()
        {
            if (RenderSettings.skybox.HasProperty("_CloudsDensity"))cloudsDensity = RenderSettings.skybox.GetFloat("_CloudsDensity");
            if (RenderSettings.skybox.HasProperty("_CloudsThickness"))cloudsThickness = RenderSettings.skybox.GetFloat("_CloudsThickness");
            if (RenderSettings.skybox.HasProperty("_DomeCurved"))domeCurved = RenderSettings.skybox.GetFloat("_DomeCurved");
            if (RenderSettings.skybox.HasProperty("_CloudsScale"))cloudsScale = RenderSettings.skybox.GetFloat("_CloudsScale");
            if (RenderSettings.skybox.HasProperty("_CloudsRotation"))cloudsRotation = RenderSettings.skybox.GetFloat("_CloudsRotation")/(2*Mathf.PI);
            if (RenderSettings.skybox.HasProperty("_timeScale"))cloudSpeed = RenderSettings.skybox.GetFloat("_timeScale")*20;
            if (RenderSettings.skybox.HasProperty("_DistortionTime"))flowSpeed = RenderSettings.skybox.GetFloat("_DistortionTime")*5;
        }

        private void setSun()
        {
            sunRotateSpeed = 360f / ((float)minPerDay * 60f);
            Vector3 lightForward = Vector3.Normalize(sunTransform.forward);
            sunLight.intensity = Mathf.SmoothStep(sunIntensity, 0, 2 * (Mathf.Clamp(lightForward.y, nightRange, setRange) - nightRange) / (setRange - nightRange));
            //Vector3 temp = sunTransform.eulerAngles;
            //sunTransform.eulerAngles = new Vector3(temp.x,temp.y, sunAltitudeAngle);
            // sunLight.transform.Rotate(Vector3.right, sunRotateSpeed * Time.deltaTime * masterTimeScale);
            //sunTransform.transform.Rotate(Vector3.forward, sunAltitudeAngle); 
            //sunTransform.rotation = Quaternion.identity * Quaternion.EulerAngles(new Vector3(temp.x, temp.y, sunAltitudeAngle));
            SetAIOTime(sunHour);
            //Debug.Log("eulerAngles:"+ sunTransform.eulerAngles.z);
            //Debug.Log("q" + sunTransform.forward);
        }
    


        //v1.2


    }

}
