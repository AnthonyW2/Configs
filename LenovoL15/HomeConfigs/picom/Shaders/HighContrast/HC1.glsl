#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;

void main(){
  vec4 c = texture2D(tex,gl_TexCoord[0].xy);
  
  float average = (c.r+c.g+c.b)/3.0;
  
  if(average < 0.2){
    c = vec4(c.r*2.0, c.g*2.0, c.b*2.0, c.a);
  }else{
    c = vec4(c.r*0.75+0.25, c.g*0.75+0.25, c.b*0.75+0.25, c.a);
  }
  
  if(invert_color){
    c = vec4(vec3(c.a,c.a,c.a) - vec3(c),c.a);
  }
  c *= opacity;
  gl_FragColor = c;
}
