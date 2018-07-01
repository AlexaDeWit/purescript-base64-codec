## Module Data.Base64

#### `encodeBase64`

``` purescript
encodeBase64 :: ArrayBuffer -> Base64
```

Encodes an ArrayBuffer into the base64 representation thereof

#### `decodeBase64`

``` purescript
decodeBase64 :: Base64 -> Maybe ArrayBuffer
```

Attempt to decode base64 content to the array buffer(byte) representation it stored internally.

#### `Base64`

``` purescript
newtype Base64
  = Base64 String
```

A boxed Base64 type to prevent accidental misuse

##### Instances
``` purescript
Eq Base64
Show Base64
```


