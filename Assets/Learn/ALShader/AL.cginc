half _GlobalBrightness = 1;		//默认为1
half _SingleBrightness = 0;		//默认为0，与_GlobalBrightness相加为1时为标准亮度

half4 GetBrightnessColor(half4 col)
{
	col.rgb *= _GlobalBrightness + _SingleBrightness;
	return col;
}