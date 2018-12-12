module Data.Base64
       ( encodeBase64
       , decodeBase64
       , Base64(..)
       ) where

import Prelude ((<<<), class Show, class Eq, (<>))
import Data.Maybe (Maybe(..))
import Data.ArrayBuffer.Types(ArrayBuffer)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Newtype (class Newtype)

-- | A boxed Base64 type to prevent accidental misuse
newtype Base64 = Base64 String

derive instance eqBase64 :: Eq Base64
derive instance newtypeBase64 :: Newtype Base64 _

-- | Show instance is for textual representations, not data representation
instance showBase64 :: Show Base64 where
  show (Base64 s) = "Base64 (" <> s <> ")"

foreign import encodeBase64Impl :: ArrayBuffer -> String

-- | Encodes an ArrayBuffer into the base64 representation thereof
encodeBase64 :: ArrayBuffer -> Base64
encodeBase64 = Base64 <<< encodeBase64Impl

foreign import decodeBase64Impl :: Fn3 (ArrayBuffer -> Maybe ArrayBuffer) (Maybe ArrayBuffer) String (Maybe ArrayBuffer)

-- | Attempt to decode base64 content to the array buffer(byte) representation it stored internally.
decodeBase64 :: Base64 -> Maybe ArrayBuffer
decodeBase64 (Base64 content) = runFn3 decodeBase64Impl Just Nothing content

