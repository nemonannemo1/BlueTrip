using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//https://answers.unity.com/questions/429476/edit-chosen-material-in-the-inspector-for-custom-e.html

using UnityEditor;

namespace AIOcontrol
{



    [CustomEditor(typeof(AIOSun))]
    public class MyScriptEditor : Editor
    {
        private AIOSun _myScript;

        // We need to use and to call an instnace of the default MaterialEditor
        private MaterialEditor _materialEditor;

        void OnEnable()
        {
            _myScript = (AIOSun)target;

            if (_myScript.AIOSkyBox != null)
            {
                // Create an instance of the default MaterialEditor
                _materialEditor = (MaterialEditor)CreateEditor(_myScript.AIOSkyBox);
            }
        }

        public override void OnInspectorGUI()
        {
            //EditorGUI.
            DrawDefaultInspector();
            GUILayout.Space(20);

            //VICTOR
            if (!Application.isPlaying)
            {
                if (_myScript.AIOSkyBox != RenderSettings.skybox)
                {
                    _myScript.AIOSkyBox = RenderSettings.skybox;
                    EditorGUILayout.PropertyField(serializedObject.FindProperty("AIOSkyBox"));


                    if (_materialEditor != null)
                    {
                        // Free the memory used by the previous MaterialEditor
                        // DestroyImmediate(_materialEditor);
                    }
                    _materialEditor = (MaterialEditor)CreateEditor(_myScript.AIOSkyBox);

                    if (_myScript.AIOSkyBox != null)
                    {
                        // Create a new instance of the default MaterialEditor
                        _materialEditor = (MaterialEditor)CreateEditor(_myScript.AIOSkyBox);

                    }
                }
            }

            //VICTOR*/



            EditorGUI.BeginChangeCheck();
            if (!Application.isPlaying)
            {
                // Draw the material field of MyScript
                EditorGUILayout.PropertyField(serializedObject.FindProperty("AIOSkyBox"));

            }


            if (EditorGUI.EndChangeCheck())
            {
                serializedObject.ApplyModifiedProperties();

                


                if (_materialEditor != null)
                {
                    // Free the memory used by the previous MaterialEditor
                    DestroyImmediate(_materialEditor);
                }

                if (_myScript.AIOSkyBox != null)
                {
                    // Create a new instance of the default MaterialEditor
                    _materialEditor = (MaterialEditor)CreateEditor(_myScript.AIOSkyBox);

                }
            }


            if (_materialEditor != null)
            {
                // Draw the material's foldout and the material shader field
                // Required to call _materialEditor.OnInspectorGUI ();
                _materialEditor.DrawHeader();

                //  We need to prevent the user to edit Unity default materials
                bool isDefaultMaterial = !AssetDatabase.GetAssetPath(_myScript.AIOSkyBox).StartsWith("Assets");

                using (new EditorGUI.DisabledGroupScope(isDefaultMaterial))
                {

                    // Draw the material properties
                    // Works only if the foldout of _materialEditor.DrawHeader () is open
                    _materialEditor.OnInspectorGUI();
                }
            }
        }

        void OnDisable()
        {
            if (_materialEditor != null)
            {
                // Free the memory used by default MaterialEditor
                DestroyImmediate(_materialEditor);
            }
        }
    }
}