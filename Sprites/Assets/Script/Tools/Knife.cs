using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Knife : MonoBehaviour
{
    private int knifeMk;
    private int knifeDamage; 
    private float knifeRange;
    
    private LayerMask coralMask = 1<<10;
    private LayerMask fishMask = 1<<13;
    private LayerMask shellMask = 1<<14;
    private LayerMask chestMask = 1<<15;

    public Transform edgePoint;
    public DecreaseFishAmount decreaseFishAmount;

    public Sprite [] knifeSkins;

    public void GetTheToolInfo(int _knifeMk, int _knifeDamage, float  _knifeRange)
    {
        knifeMk = _knifeMk;
        knifeDamage = _knifeDamage;
        knifeRange = _knifeRange;
    }

    private string currentSceneName;

    void Start()
    {
        currentSceneName = SceneManager.GetActiveScene().name;
        UpdateSkin();
    }

    private int KnifeDamage()
    {
        return knifeDamage + Random.Range(-10,10);
    }

    public void UpdateSkin()
    {
        this.GetComponent<SpriteRenderer>().sprite = knifeSkins[Tools.Instance.knifeMK];
    }

    void Update()
    {
        if(Input.GetButtonDown("Fire1") && currentSceneName != "Shop")    // when left mouse is pressed start the laser Renderer
        {
            KnifeSwing();
        }
    }

    void OnDrawGizmos()
    {
        if(edgePoint == null)
        return;

        Gizmos.DrawWireSphere(edgePoint.position, knifeRange);
    }

    private void KnifeSwing()
    {
        FishAttack();
        CoralBreakDown();
        ShellBreakDown();
        ChestBreakDown();
    }

    public void Reset()
    {
        transform.localScale = Vector3.one;
    }

    private void FishAttack()
    {   
        Collider2D[] hitFish = Physics2D.OverlapCircleAll(edgePoint.position, knifeRange, fishMask);
        foreach(Collider2D fish in hitFish)
        {
            if(fish.transform.parent.parent.gameObject.GetComponent<FishStats>() != null)
            {
                fish.transform.parent.parent.gameObject.GetComponent<FishStats>().FishDamaged(KnifeDamage());
                decreaseFishAmount.RemoveCaughtOrDeadFish(fish.transform.parent.parent.gameObject);
            }
        }
    }

    private void CoralBreakDown()
    {   
        Collider2D[] hitCoral = Physics2D.OverlapCircleAll(edgePoint.position, knifeRange, coralMask);

        foreach(Collider2D coral in hitCoral)
        {
            if(coral.GetComponent<CoralInfo>() != null)
            {
                coral.GetComponent<CoralInfo>().Breakdown(knifeMk + 1);
            }
        }
    }

    private void ShellBreakDown()
    {   
        Collider2D[] hitShell = Physics2D.OverlapCircleAll(edgePoint.position, knifeRange, shellMask);

        foreach(Collider2D shell in hitShell)
        {
            if(shell.GetComponent<ShellInfo>() != null)
            {
                shell.GetComponent<ShellInfo>().Breakdown(knifeMk + 1);
            }
        }
    }

    private void ChestBreakDown()
    {   
        Collider2D[] hitChest = Physics2D.OverlapCircleAll(edgePoint.position, knifeRange, chestMask);

        foreach(Collider2D chest in hitChest)
        {
            if(chest.GetComponent<Chest>() != null)
            {
                chest.GetComponent<Chest>().Breakdown(knifeMk + 1);
            }
        }
    }
}
