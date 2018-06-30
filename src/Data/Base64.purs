module Data.Base64
       ( encodeBase64
       , decodeBase64
       , Base64(..)
       ) where

import Prelude ((<<<), class Show, class Eq, (<>))
import Data.Maybe (Maybe(..))
import Data.ArrayBuffer.Types(ArrayBuffer)
import Data.Function.Uncurried (Fn3, runFn3)

newtype Base64 = Base64 String

derive instance eqBase64 :: Eq Base64

instance showBase64 :: Show Base64 where
  show (Base64 s) = "Base64 (" <> s <> ")"

foreign import encodeBase64Impl :: ArrayBuffer -> String

encodeBase64 :: ArrayBuffer -> Base64
encodeBase64 = Base64 <<< encodeBase64Impl

foreign import decodeBase64Impl :: Fn3 (ArrayBuffer -> Maybe ArrayBuffer) (Maybe ArrayBuffer) String (Maybe ArrayBuffer)

decodeBase64 :: Base64 -> Maybe ArrayBuffer
decodeBase64 (Base64 content) = runFn3 decodeBase64Impl Just Nothing content

