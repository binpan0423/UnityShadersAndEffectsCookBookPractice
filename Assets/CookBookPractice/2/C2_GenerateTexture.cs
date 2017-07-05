using UnityEngine;
using System.Collections;
using UnityEngine.UI;

//生成纹理贴图
public class C2_GenerateTexture : MonoBehaviour 
{
	void Start () 
    {
        GameObject.Find("RawImage").GetComponent<RawImage>().texture = GenerateTexture();
	}
	
	void Update () 
    {
	
	}


    private const int widthAndHeight = 256;
    private Vector2 centerPos = new Vector2(128, 128);
    private Texture2D GenerateTexture()
    {
        Texture2D texture = new Texture2D(widthAndHeight,widthAndHeight);

        for(int i = 0; i != widthAndHeight ; ++i)
            for(int j = 0;j!= widthAndHeight ; ++j)
            {
                //使用任意一种方式生成颜色
                Vector2 currentPos = new Vector2(i, j);
                float dis = Vector2.Distance(currentPos, centerPos)/ (widthAndHeight/2);
                float colorR = 1- Mathf.Clamp01(dis);
                Color c = new Color(colorR, colorR, colorR, 1);
                texture.SetPixel(i, j, c); //IMP
            }
        texture.Apply();
        return texture;

    }
}
