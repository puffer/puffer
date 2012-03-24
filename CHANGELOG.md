## 0.1.2 \[ In Development \] \[ Branch: master \]

### New Behavior

*   Authorization-related classes as PufferUser or PufferUserController are removed
    from engine and moved to generator `puffer:puffer_user`

### New features

*   Created TestCase and ExampleGroup for components. It can be used for
    testing or specing newly created custom components.

## 0.1.1

### New Behavior

*   Unified behavior for all built-in app classes (controller and models).
    Now there are one or more versions inside modules and default version is inherited.
    See more - [default behaviors](https://github.com/puffer/puffer/wiki/Default-behaviors)
    No more autoconfig attempts.

### New features

*   `per_page` config option.

*   Grid index controller.

*   Carrierwave component implemented.

*   Rails 3.2 compatible.