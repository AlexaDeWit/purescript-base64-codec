module Test.Main where

import Prelude

import Data.ArrayBuffer.ArrayBuffer as AB
import Data.ArrayBuffer.Types as AT
import Data.Base64 as B64
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Test.QuickCheck (quickCheck, (<?>))
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)

newtype ABuffer = ABuffer AT.ArrayBuffer

buffer :: ABuffer -> AT.ArrayBuffer
buffer (ABuffer b) = b

instance arbitraryArrayBuffer :: Arbitrary ABuffer where
  arbitrary = map (ABuffer <<< AB.fromIntArray) arbitrary

newtype Base64 = Base64 B64.Base64

instance arbitraryBase64 :: Arbitrary Base64 where
  arbitrary = map (Base64 <<< B64.encodeBase64 <<< buffer) arbitrary

newtype NotBase64 = NotBase64 String

instance arbitraryNotBase64 :: Arbitrary NotBase64 where
  arbitrary = map (NotBase64 <<< ((<>) "å")) arbitrary

main :: Effect Unit
main = do
  quickCheck
    \(Base64 b) ->
      b == (B64.encodeBase64 $ B64.decodeBase64 b)
      <?> "Isormorphic base64 round trip failed"
  quickCheck
    \(NotBase64 s) ->
      Nothing == B64.fromString s
      <?> "Received a Just from an impossible string when checking that it was base64 encoded."
  quickCheck
    \(Base64 b) ->
      Just b == (B64.fromString $ B64.runBase64 b)
      <?> "Failed to parse a string as base64 despite it being valid."
      


