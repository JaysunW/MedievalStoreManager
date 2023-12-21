using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rope : MonoBehaviour
{
    private Vector2 lineEnd;
    private Vector2 lineStart;

    public LineRenderer l_lineRenderer;

    public void Draw2DRay(Vector2 startPos, Vector2 endPos)
    {
        l_lineRenderer.SetPosition(0, startPos);
        l_lineRenderer.SetPosition(1, endPos);
    }
}
