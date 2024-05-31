Shader "Unlit/ScreenFader" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100
    Fog {Mode Off}
    Cull Off

    ZTest Always
    Blend SrcAlpha OneMinusSrcAlpha
    Color [_Color]

    Pass {}
}
}

