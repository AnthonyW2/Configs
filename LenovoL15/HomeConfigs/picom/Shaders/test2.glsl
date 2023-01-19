#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;



varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float range;
uniform vec4 colourMatch;
uniform vec4 colourReplace = new vec4(255,0,0);

void main(){
  vec4 pixelColour = texture2D(tex,gl_TexCoord[0].xy);
  
  float newRange = range / 255.0;
  
  if(abs(pixelColour.r-colourMatch.r) <= newRange){
        if(abs(pixelColour.b-colourMatch.b) <= newRange){
            if(abs(pixelColour.g-colourMatch.g) <= newRange){
                pixelColour.rgb = colourReplace.rgb;
            }
        }
    }
  
  gl_FragColor = pixelColour;
}
