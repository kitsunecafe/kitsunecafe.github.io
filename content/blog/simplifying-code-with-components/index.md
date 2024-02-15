{% extends "../../../layouts/index.html" %}

{% block content %}
# Simplifying Code with Components

Unity is a component-based game engine. Without any context, "component" is a nebulous and vague term. Understanding what a component *is* becomes crucial to understanding Unity. In Unity's [Introduction to components](https://docs.unity3d.com/Manual/Components.html), they provide an unsatisfactory definition of a component.

> Components define the behaviour of that GameObject.

While this is entirely accurate, especially within the context of Unity, it fails to provide a good idea of the fundamental concepts behind components.

# What is a component?

[Game Programming Pattern](https://gameprogrammingpatterns.com/component.html)'s definition provides more insight into the purpose of a component.

> Allow a single entity to span multiple domains without coupling the domains to each other.

Without reading further into the article, I find the definition sterile and hard to visualize. That said, I would highly recommend reading the rest article and the entirety of the book - it's worth it!

I'll make an effort to define a component as well.

> A component is a single, reusable domain behavior with an intuitive interface. 

As much as possible, a component should attempt to focus on a single behavior within a single domain. It should have a clear and simple interface to allow its entity, other entities, and other components to interact with its behavior.

I find that Unity's [`CharacterController`](https://docs.unity3d.com/ScriptReference/CharacterController.html) is an example of a good component. It exposes two public methods, [`Move(Vector3)`](https://docs.unity3d.com/ScriptReference/CharacterController.Move.html) and [`SimpleMove(Vector3)`](https://docs.unity3d.com/ScriptReference/CharacterController.SimpleMove.html).

`Move(Vector3 motion)` "supplies the movement of a GameObject with an attached CharacterController component." It takes the desired movement vector and attempts to displace the GameObject to which it is attached. It makes no assumptions about gravity since different games have different requirements for gravity.

`SimpleMove(Vector3 speed)` "moves the character with speed." Speed is a movement vector -- a direction and speed to move per second. This method *does* make assumptions about gravity.

`CharacterController` hides the complexity of ground collision, physics interactions, and movement interpolation. Additionally, the two methods hide or reveal certain complexities about how the component moves the character. Certain Unity-isms regarding Collision events notwithstanding, the interface is *very* simple and obvious.


# When should I create a new component?

The obvious answer is whenever you need a new behavior. If you're unsure, it is always possible and encouraged to review and refactor code to identify the need for abstractions like a new component.

Using movement as an example again, should character rotation be part of the character movement component? The two often occur simultaneously and even rely on one another. It makes sense to combine rotation and displacement into the same behavior. There are likely cases where this may not be true, and in that instance, the developer should split them into separate components.

Should jumping be included in the movement component? I can imagine many scenarios where an entity would need to move but not jump. In those cases, it makes sense to separate them into different components.

I obviously won't iterate every possible decision on whether or not I would personally separate a behavior into a new component. It's important to make thoughtful decisions about your code architecture, similar to the examples above.

# Making a movement component

Let's use Unity's [`CharacterController.Move`](https://docs.unity3d.com/ScriptReference/CharacterController.Move.html) example.

```cs
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Example : MonoBehaviour
{
    private CharacterController controller;
    private Vector3 playerVelocity;
    private bool groundedPlayer;
    private float playerSpeed = 2.0f;
    private float jumpHeight = 1.0f;
    private float gravityValue = -9.81f;

    private void Start()
    {
        controller = gameObject.AddComponent<CharacterController>();
    }

    void Update()
    {
        groundedPlayer = controller.isGrounded;
        if (groundedPlayer && playerVelocity.y < 0)
        {
            playerVelocity.y = 0f;
        }

        Vector3 move = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
        controller.Move(move * Time.deltaTime * playerSpeed);

        if (move != Vector3.zero)
        {
            gameObject.transform.forward = move;
        }

        // Changes the height position of the player..
        if (Input.GetButtonDown("Jump") && groundedPlayer)
        {
            playerVelocity.y += Mathf.Sqrt(jumpHeight * -3.0f * gravityValue);
        }

        playerVelocity.y += gravityValue * Time.deltaTime;
        controller.Move(playerVelocity * Time.deltaTime);
    }
}
```

Although it's not relevant, this example goes against Unity's advice to not call `Move` or `SimpleMove` more than once per frame.

One of the first things to notice about this component is that it crosses two domains: input and movement. Let's start by separating those concerns.

## Separating concerns

```cs
public class InputProvider : MonoBehaviour
{
  public Vector2 CurrentDirection { get; protected set; }
  public bool WantsToJump { get; protected set; }

  private void Update()
  {
    CurrentDirection = new Vector2(
      Input.GetAxis("Horizontal"),
      Input.GetAxis("Vertical")
    );

    WantsToJump = Input.GetButton("Jump");
  }
}
```

It doesn't seem like much, but small components like this one help separate unrelated logic to make them more composable. 
Let's refactor the remaining example code.

We'll start by renaming the class and the file to `EntityMovement` and `EntityMovement.cs`.

```cs
public class EntityMovement : MonoBehaviour
```

Now let's add a reference to our new `InputProvider` component.

```cs
public class EntityMovement : MonoBehaviour
{
  private InputProvider input;
  // ...

  private void Start()
  {
    //...
    input = gameObject.GetComponent<InputProvider>();
  }
```

With our reference to `InputProvider`, we can replace the existing `Input` references.

```cs
  private void Update()
  {
    // ...
    Vector3 move = new Vector3(input.CurrentDirection.x, 0, input.CurrentDirection.y);
    controller.Move(move * Time.deltaTime * playerSpeed);

    if (move != Vector3.zero)
    {
        gameObject.transform.forward = move;
    }

    if (input.WantsToJump && groundedPlayer)
    {
        playerVelocity.y += Mathf.Sqrt(jumpHeight * -3.0f * gravityValue);
    }
    // ..
  }
```

Create a sphere with the `EntityMovement` and `InputProvider` components and move it with WASD or the arrow keys. It should operate like Unity's `Example` component, but now we've separated input handling from movement!
Unfortunately, the changes we've made only illustrate the concept of splitting concerns without actually having done anything practical. What *would* be useful is if these components were usable by more than the player character. Let's refactor our code to make that possible.

## Making it reusable

For our components to be reusable, `InputProvider` needs to act as a generic interface rather than a thin proxy to `Input`. An easy way to accomplish this would be to refactor `InputProvider` as a C# `interface`. Thankfully Unity's `GetComponent` works with classes and interfaces. Be sure to remove `InputProvider` from the existing GameObject.

```cs
public interface InputProvider
{
  Vector2 CurrentDirection { get; }
  bool WantsToJump { get; }
}

```

A new component is required to implement the interface, `PlayerInputProvider`. It will contain the implementation details that previously lived in `InputProvider`.

```cs
public class PlayerInputProvider : MonoBehaviour, InputProvider
{
  public Vector2 CurrentDirection { get; protected set; }
  public bool WantsToJump { get; protected set; }

  private void Update()
  {
    CurrentDirection = new Vector2(
      Input.GetAxis("Horizontal"),
      Input.GetAxis("Vertical")
    );

    WantsToJump = Input.GetButton("Jump");
  }
}
```

Attach `PlayerInputProvider` to the player object and ensure the character moves again. A future component could be `EnemyInputProvider` which determines movement based on a `NavMeshAgent`. 
{% endblock content %}

