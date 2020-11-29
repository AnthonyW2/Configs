#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;

int TYPE = 3;

void main(){
  vec4 c = texture2D(tex,gl_TexCoord[0].xy);
  
  //c = vec4(c.r,c.g,c.b,c.a);
  //c = vec4(sin(c.r),sin(c.g),sin(c.b),c.a);
  //c = vec4(c.g,c.b,c.r,c.a);
  //c = vec4(c.b,c.r,c.g,c.a);
  //c = vec4((c.b+c.g)/2.0,(c.r+c.b)/2.0,(c.g+c.r)/2.0,c.a);
  
  float average = (c.r+c.g+c.b)/3.0;
  
  if(TYPE == 0){
    // High contrast 1
    if(average < 0.2){
      c = vec4(c.r*2.0, c.g*2.0, c.b*2.0, c.a);
    }else{
      c = vec4(c.r*0.75+0.25, c.g*0.75+0.25, c.b*0.75+0.25, c.a);
    }
  }else if(TYPE == 1){
    // High contrast 2
    if(average < 0.1){
      c = vec4(c.r*4.0, c.g*4.0, c.b*4.0, c.a);
    }else if(average > 0.9){
      c = vec4(c.r*4.0-3, c.g*4.0-3, c.b*4.0-3, c.a);
    }else{
      c = vec4(c.r/4.0+0.375, c.g/4.0+0.375, c.b/4.0+0.375, c.a);
    }
  }else if(TYPE == 2){
    // 65536 colours
    c = vec4(round(c.r*16)/16.0, round(c.g*16)/16.0, round(c.b*16)/16.0, c.a);
  }else if(TYPE == 3){
    // 256 colours
    c = vec4(round(c.r*8)/8.0, round(c.g*8)/8.0, round(c.b*8)/8.0, c.a);
  }else if(TYPE == 4){
    // 64 colours
    c = vec4(round(c.r*4)/4.0, round(c.g*4)/4.0, round(c.b*4)/4.0, c.a);
  }
  
  
  if(invert_color){
    c = vec4(vec3(c.a,c.a,c.a) - vec3(c),c.a);
  }
  c *= opacity;
  gl_FragColor = c;
}
