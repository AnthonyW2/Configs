#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;

void main(){
  vec4 c = texture2D(tex,gl_TexCoord[0].xy);
  
  float average = (c.r+c.g+c.b)/3.0;
  
  if(average < 0.1){
    c = vec4(c.r*4.0, c.g*4.0, c.b*4.0, c.a);
  }else if(average > 0.9){
    c = vec4(c.r*4.0-3, c.g*4.0-3, c.b*4.0-3, c.a);
  }else{
    c = vec4(c.r/4.0+0.375, c.g/4.0+0.375, c.b/4.0+0.375, c.a);
  }
  
  if(invert_color){
    c = vec4(vec3(c.a,c.a,c.a) - vec3(c),c.a);
  }
  c *= opacity;
  gl_FragColor = c;
}
