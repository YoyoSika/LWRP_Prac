using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.LWRP;

public class YoyoPass : ScriptableRenderPass
{
    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer buff = CommandBufferPool.Get("233");
        buff.GetTemporaryRT(666, renderingData.cameraData.cameraTargetDescriptor);
        buff.Blit(colorAttachment, 666);
        //CameraEvent.AfterEverything
        //Camera cam;
        //buff.SetGlobalVector()
        CommandBufferPool.Release(buff);
        //throw new System.NotImplementedException();
    }

}


public class YoyoFeature : ScriptableRendererFeature
{
    private YoyoPass mPass;
    public float testFloatProperty = 0.66f;
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(mPass);
    }

    public override void Create()
    {
        mPass = new YoyoPass();
    }
}
