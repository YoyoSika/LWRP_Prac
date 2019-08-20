using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(InstanceMgr))]
public class InstanceMgrEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        GUILayout.Space(30f);
        InstanceMgr targetMgr = target as InstanceMgr;

        GUILayout.Space(10f);

        if (GUILayout.Button("Collect As Data")) {
            // 把东西给收集起来
            Debug.Log(target.name);
            targetMgr.Collect();
        }
        GUILayout.Space(10f);

        if (GUILayout.Button("PreviewData")) {
            // 预览
        }
    }
}
