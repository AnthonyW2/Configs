uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

void main(){
  vec4 c = texture2D(tex, gl_TexCoord[0].xy);
  c = vec4(c.r, c.g, c.b*0.9, c.a);
  gl_FragColor = c;
}
