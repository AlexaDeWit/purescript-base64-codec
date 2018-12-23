module Data.Base64
       ( encodeBase64
       , decodeBase64
       , Base64
       , runBase64
       ) where

import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..), fromJust)
import Partial.Unsafe (unsafePartial)
import Prelude ((<<<), class Show, class Eq, (<>), ($))

-- | A boxed Base64 type to prevent accidental misuse
newtype Base64 = Base64 String

derive instance eqBase64 :: Eq Base64

-- | Show instance is for textual representations, not data representation
instance showBase64 :: Show Base64 where
  show (Base64 s) = "Base64 (" <> s <> ")"

foreign import encodeBase64Impl :: ArrayBuffer -> String

-- | Encodes an ArrayBuffer into the base64 representation thereof
encodeBase64 :: ArrayBuffer -> Base64
encodeBase64 = Base64 <<< encodeBase64Impl

foreign import decodeBase64Impl :: Fn3 (ArrayBuffer -> Maybe ArrayBuffer) (Maybe ArrayBuffer) String (Maybe ArrayBuffer)

-- | Decode base64 content to the array buffer(byte) representation it stored internally.
decodeBase64 :: Base64 ->  ArrayBuffer
decodeBase64 (Base64 content) = unsafePartial $ fromJust $ runFn3 decodeBase64Impl Just Nothing content

runBase64 :: Base64 -> String
runBase64 (Base64 s) = s