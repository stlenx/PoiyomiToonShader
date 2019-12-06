#ifndef POI_GLITTER
    #define POI_GLITTER
    
    half3 _GlitterColor;
    UNITY_DECLARE_TEX2D_NOSAMPLER(_GlitterMask); float4 _GlitterMask_ST;
    UNITY_DECLARE_TEX2D_NOSAMPLER(_GlitterColorMap); float4 _GlitterColorMap_ST;
    half _GlitterSpeed;
    half _GlitterBrightness;
    float _GlitterFrequency;
    float _GlitterJitter;
    half _GlitterSize;
    half _GlitterContrast;
    half _GlitterAngleRange;
    half _GlitterMinBrightness;
    half _GlitterBias;
    //1/7
    #define K 0.142857142857
    //3/7
    #define Ko 0.428571428571
    
    float3 mod(float3 x, float y)
    {
        return x - y * floor(x / y);
    }
    float2 mod(float2 x, float y)
    {
        return x - y * floor(x / y);
    }
    
    // Permutation polynomial: (34x^2 + x) mod 289
    float3 Permutation(float3 x)
    {
        return mod((34.0 * x + 1.0) * x, 289.0);
    }
    
    /*
    
    float fBm_F1_F0_Poi(float2 p)
    {
        float2 F = inoise(p * _GlitterFrequency, _GlitterJitter) * .7;
        return F.y - F.x;
    }
    
    float fBm_F1_F0(float2 p, int octaves)
    {
        float freq = _GlitterFrequency, amp = 0.5;
        float sum = 0;
        for (int i = 0; i < octaves; i ++)
        {
            float2 F = inoise(p * freq, _GlitterJitter) * amp;
            
            sum += 0.1 + sqrt(F[1]) - sqrt(F[0]);
        }
        return sum;
    }
    
    void Unity_NormalFromHeight_World(float In, out float3 Out)
    {
        float3 worldDirivativeX = ddx(float3(poiMesh.localPos.xyz) * 100);
        float3 worldDirivativeY = ddy(float3(poiMesh.localPos.xyz) * 100);
        float3 crossX = cross(poiTData.tangentTransform[2].xyz, worldDirivativeX);
        float3 crossY = cross(poiTData.tangentTransform[2].xyz, worldDirivativeY);
        float3 d = abs(dot(crossY, worldDirivativeX));
        float3 inToNormal = ((((In + ddx(In)) - In) * crossY) + (((In + ddy(In)) - In) * crossX)) * sign(d);
        inToNormal.y *= -1.0;
        Out = normalize((d * poiTData.tangentTransform[2].xyz) - inToNormal);
    }
    
    void Unity_NormalFromHeight_Tangent(float In, out float3 Out)
    {
        float3 worldDirivativeX = ddx(float3(poiMesh.uv[0], 0) * 100);
        float3 worldDirivativeY = ddy(float3(poiMesh.uv[0], 0) * 100);
        float3 crossX = cross(poiTData.tangentTransform[2].xyz, worldDirivativeX);
        float3 crossY = cross(poiTData.tangentTransform[2].xyz, worldDirivativeY);
        float3 d = abs(dot(crossY, worldDirivativeX));
        float3 inToNormal = ((((In + ddx(In)) - In) * crossY) + (((In + ddy(In)) - In) * crossX)) * sign(d);
        inToNormal.y *= -1.0;
        Out = ((d * poiTData.tangentTransform[2].xyz) - inToNormal);
        Out = mul(poiTData.tangentToWorld, Out).xyz;
    }
    
    void poiMathMagic(float In, out float3 Out)
    {
        float worldDirivativeX = ddx(In * _GlitterSpeed);
        float worldDirivativeY = ddy(In * _GlitterSpeed);
        float thing = sqrt(1 - worldDirivativeX * worldDirivativeX - worldDirivativeY * worldDirivativeY);
        Out = normalize(float3(worldDirivativeX, worldDirivativeY, thing)) * 16;
    }
    
    float3 HeightToNormal(float height, float3 normal, float3 pos)
    {
        float3 worldDirivativeX = ddx(pos);
        float3 worldDirivativeY = ddy(pos);
        float3 crossX = cross(normal, worldDirivativeX);
        float3 crossY = cross(normal, worldDirivativeY);
        float3 d = abs(dot(crossY, worldDirivativeX));
        float3 inToNormal = ((((height + ddx(height)) - height) * crossY) + (((height + ddy(height)) - height) * crossX)) * sign(d);
        inToNormal.y *= -1.0;
        return normalize((d * normal) - inToNormal);
    }
    
    float3 WorldToTangentNormalfloattor(float3 normal)
    {
        float3 t2w0 = UnityObjectToWorldNormal(float3(1, 0, 0));
        float3 t2w1 = UnityObjectToWorldNormal(float3(0, 1, 0));
        float3 t2w2 = UnityObjectToWorldNormal(float3(0, 0, 1));
        float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
        return normalize(mul(t2w, normal));
    }
    */
    float3 randomFloat3(float2 Seed, float maximum)
    {
        return(.5 + float3(
            frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(float2(Seed), float2(12.9898, 78.233))) * 43758.5453)
        ) * .5) * (maximum);
    }
    
    float3 randomFloat3Range(float2 Seed, float Range)
    {
        return(float3(
            frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
        ) * 2 - 1) * Range;
    }
    
    float3 randomFloat3WiggleRange(float2 Seed, float Range)
    {
        float3 rando = (float3(
            frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
            frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
        ) * 2 - 1);
        float speed = 1 + _GlitterSpeed;
        return float3(sin((_Time.x + rando.x * pi) * speed), sin((_Time.x + rando.y * pi) * speed), sin((_Time.x + rando.z * pi) * speed)) * Range;
    }
    
    void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
    {
        float randomno = frac(sin(dot(Seed, float2(12.9898, 78.233))) * 43758.5453);
        Out = lerp(Min, Max, randomno);
    }
    
    float2 random2(float2 p)
    {
        return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
    }
    
    void applyGlitter(inout float3 finalEmission, inout float4 finalColor)
    {
        
        
        // Scale
        float2 st = poiMesh.uv[0] * _GlitterFrequency;
        
        // Tile the space
        float2 i_st = floor(st);
        float2 f_st = frac(st);
        
        float m_dist = 10.;  // minimun distance
        float2 m_point = 0;        // minimum point
        float2 randoPoint = 0;
        for (int j = -1; j <= 1; j ++)
        {
            for (int i = -1; i <= 1; i ++)
            {
                float2 neighbor = float2(i, j);
                float2 pos = random2(i_st + neighbor);
                float2 rando = pos;
                pos = 0.5 + 0.5 * sin(_GlitterJitter * 6.2831 * pos);
                float2 diff = neighbor + pos - f_st;
                float dist = length(diff);
                
                if (dist < m_dist)
                {
                    m_dist = dist;
                    m_point = pos;
                    randoPoint = rando;
                }
            }
        }
        
        // Assign a color using the closest point position
        //color += dot(m_point, float2(.3, .6));
        
        // Add distance field to closest point center
        // color.g = m_dist;
        
        // Show isolines
        //color -= abs(sin(40.0 * m_dist)) * 0.07;
        
        // Draw cell center
        half glitterAlpha = (1. - step(_GlitterSize, m_dist));
        float3 randomRotation = 0;
        UNITY_BRANCH
        if (_GlitterSpeed > 0)
        {
            randomRotation = randomFloat3WiggleRange(randoPoint, _GlitterAngleRange);
        }
        else
        {
            randomRotation = randomFloat3Range(randoPoint, _GlitterAngleRange);
        }
        float3 norm = poiMesh.normals[0];
        if(poiMesh.isFrontFace != 1)
        {
            norm *= -1;
        }
        
        float3 glitterReflectionDirection = normalize(lerp(-poiCam.viewDir, mul(poiRotationMatrixFromAngles(randomRotation), norm), glitterAlpha));
        float3 finalGlitter = lerp(0, _GlitterMinBrightness, glitterAlpha) + max(pow(dot(lerp(glitterReflectionDirection, poiCam.viewDir, _GlitterBias), poiCam.viewDir), _GlitterContrast) * _GlitterBrightness, 0);
        _GlitterColor *= UNITY_SAMPLE_TEX2D_SAMPLER(_GlitterColorMap, _MainTex, TRANSFORM_TEX(poiMesh.uv[0], _GlitterColorMap));
        _GlitterColor *= UNITY_SAMPLE_TEX2D_SAMPLER(_GlitterMask, _MainTex, TRANSFORM_TEX(poiMesh.uv[0], _GlitterMask));
        finalEmission += finalGlitter * _GlitterColor;
        // Draw grid
        //color.r += step(.98, f_st.x) + step(.98, f_st.y);
    }
    
#endif


/*
float2 F = inoise(poiMesh.uv[0] * _GlitterFrequency, _GlitterJitter) * .7;
float HeightMap = (F.y - F.x) * _GlitterSpeed;
float3 normal = UnityObjectToWorldNormal(float3(0, 0, 1));
normal = HeightToNormal(HeightMap, normal, poiMesh.worldPos);
normal = WorldToTangentNormalfloattor(normal);

//Unity_NormalFromHeight_World((HeightMap), test);
//poiMathMagic((F.y - F.x), test);
//test = (UnpackScaleNormal(float4(test, 1),40));

test = normalize(
    test.x * poiMesh.tangent +
    test.y * poiMesh.bitangent +
    test.z * poiMesh.normals[0]
);

//finalColor.rgb = dot(test, -poiCam.viewDir) * _GlitterBrightness;
finalColor.rgb = normal;
*/
/*
half circleGradient;
half3 circleColor;
inoise(poiMesh.uv[0] * _GlitterFrequency, circleGradient, circleColor);
half circle = 1 - pow(max(0.0, abs(circleGradient) * _GlitterSpeed - 1), 2);
float2 P = poiMesh.uv[0] * _GlitterFrequency;
float2 Pi = mod(floor(P), 289.0);
float2 Pf = ceil(P) * .03;
finalColor.rgb = circle * circleColor;

void inoise(float2 P, out half cirlceGradient, out half3 circleColor)
{
    float2 Pi = mod(floor(P), 289.0);
    float2 Pf = frac(P);
    float3 oi = float3(-1.0, 0.0, 1.0);
    float3 of = float3(-0.5, 0.5, 1.5);
    float3 px = Permutation(Pi.x + oi);
    
    float3 p, ox, oy, dx, dy;
    float2 F = 1e6;
    
    for (int i = 0; i < 3; i ++)
    {
        p = Permutation(px[i] + Pi.y + oi); // pi1, pi2, pi3
        ox = frac(p * K) - Ko;
        oy = mod(floor(p * K), 7.0) * K - Ko;
        dx = Pf.x - of[i] + _GlitterJitter * ox;
        dy = Pf.y - of + _GlitterJitter * oy;
        
        float3 d = dx * dx + dy * dy; // di1, di2 and di3, squared
        
        //find the lowest and second lowest distances
        for (int n = 0; n < 3; n ++)
        {
            if (d[n] < F[0])
            {
                F[1] = F[0];
                F[0] = d[n];
            }
            else if(d[n] < F[1])
            {
                F[1] = d[n];
            }
        }
    }
    circleColor = randomFloat3(Pi, 1);
    cirlceGradient = F.x;
}
*/