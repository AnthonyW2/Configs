#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;

void main(){
  vec4 c = texture2D(tex,gl_TexCoord[0].xy);
  
  //c = vec4(c.r+mod(time/10000.0,1.0),c.g,c.b,c.a);
  c = vec4(c.r+sin(time/1000.0)/2.0,c.g,c.b,c.a);
  
  if(invert_color){
    c = vec4(vec3(c.a,c.a,c.a) - vec3(c),c.a);
  }
  c *= opacity;
  gl_FragColor = c;
}
