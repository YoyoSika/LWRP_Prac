using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.LWRP;

public class YoyoPass : ScriptableRenderPass
{
    public float testFloatProperty = 0.66f;
    const string m_ProfilerTag = "YoyoInstance";
    Material mInstanceMat;
    InstanceMgr instanceData;

    public YoyoPass(RenderPassEvent mPassEvent , Material instanceMat)
    {
        renderPassEvent = mPassEvent;
        mInstanceMat = instanceMat;
    }

    public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
    {
        base.Configure(cmd, cameraTextureDescriptor);
        instanceData = InstanceMgr.GetInstance();
        
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer buff = CommandBufferPool.Get(m_ProfilerTag);
        //Rock
        MaterialPropertyBlock block = new MaterialPropertyBlock();
        block.SetVectorArray("_ColorTest",instanceData.colorArray);
        buff.DrawMeshInstanced(instanceData.meshRock, 0, instanceData.matRock, 0, instanceData.matrixArray, instanceData.matrixArray.Length, block);

        context.ExecuteCommandBuffer(buff); 
        CommandBufferPool.Release(buff);
    }

}


public class YoyoFeature : ScriptableRendererFeature
{
    private YoyoPass mPass;
    
    public float testFloatProperty = 0.66f;
    public RenderPassEvent testRenderEvnt = RenderPassEvent.AfterRenderingOpaques;
    public Material instanceMat;

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(mPass);
    }

    public override void Create()
    {
        mPass = new YoyoPass(testRenderEvnt , instanceMat);

    }
}
