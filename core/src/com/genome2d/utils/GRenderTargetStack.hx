package com.genome2d.utils;
import com.genome2d.context.IContext;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.textures.GContextTexture;
class GRenderTargetStack {
    static private var g2d_stack:Array<GContextTexture>;
    static private var g2d_transforms:Array<GMatrix3D>;

    static public function pushRenderTarget(p_target:GContextTexture, p_transform:GMatrix3D):Void {
        if (g2d_stack == null) {
            g2d_stack = new Array<GContextTexture>();
            g2d_transforms = new Array<GMatrix3D>();
        }
        g2d_stack.push(p_target);
        g2d_transforms.push(p_transform);
    }

    static public function popRenderTarget(p_context:IContext):Void {
        if (g2d_stack == null) return null;
        p_context.setRenderTarget(g2d_stack.pop(), g2d_transforms.pop(), false);
    }
}
