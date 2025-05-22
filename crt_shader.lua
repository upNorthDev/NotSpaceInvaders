local retroShader = love.graphics.newShader([[
    extern number time;
    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
    {
        float offset = 0.0015;

        float r = texture2D(tex, texCoord + vec2(offset, 0)).r;
        float g = texture2D(tex, texCoord).g;
        float b = texture2D(tex, texCoord - vec2(offset, 0)).b;

        vec3 rgb = vec3(r, g, b);

        float scanline = sin(screenCoord.y * 3.14159 * 0.5) * 0.05;
        rgb -= scanline;

        return vec4(rgb * color.rgb, texture2D(tex, texCoord).a * color.a);
    }
]])


return retroShader
