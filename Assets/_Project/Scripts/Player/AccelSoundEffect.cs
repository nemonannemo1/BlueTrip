using UnityEngine;
using DG.Tweening;

public class AccelSoundEffect : MonoBehaviour
{
    [SerializeField] AudioSource _audioSource;

    public void Start()
    {
        _audioSource.PlayOneShot(_audioSource.clip);
        _audioSource.DOFade(0f, 2f);
        Destroy(gameObject, 3f);
    }
}
