half _GlobalBrightness = 1;		//Ĭ��Ϊ1
half _SingleBrightness = 0;		//Ĭ��Ϊ0����_GlobalBrightness���Ϊ1ʱΪ��׼����

half4 GetBrightnessColor(half4 col)
{
	col.rgb *= _GlobalBrightness + _SingleBrightness;
	return col;
}