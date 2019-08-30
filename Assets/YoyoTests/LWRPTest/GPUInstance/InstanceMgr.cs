using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstanceMgr : MonoBehaviour
{
    public static InstanceMgr mInstance;
    public static InstanceMgr GetInstance()
    {
        if (mInstance == null) {
            GameObject mgr = GameObject.Find("InstanceMgr");
            if (mgr == null)
                return null;
            mInstance = mgr.GetComponent<InstanceMgr>();
        }

        return mInstance;
    }

    public  Mesh meshRock;
    public  Material matRock;
    public  Mesh meshGrass;

    public GameObject[] Objects;
    public Matrix4x4[] matrixArray;
    public Vector4[] colorArray;



    private void Awake()
    {
        if (mInstance == null)
            mInstance = this;
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void Collect()
    {
        Objects = GameObject.FindGameObjectsWithTag("Instance");
        matrixArray = new Matrix4x4[Objects.Length];
        colorArray = new Vector4[Objects.Length];
        for (int i = 0; i < Objects.Length; i++) {
            var transform = Objects[i].transform;
            matrixArray[i] = Matrix4x4.identity;
            matrixArray[i].SetTRS(transform.position, transform.rotation, transform.localScale);
            colorArray[i] = Color.white * Random.Range(0,0.618f) ;
            Objects[i].SetActive(false);
        }
    }
}

