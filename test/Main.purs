module Test.Main where

import Prelude
import Effect (Effect)
import Test.QuickCheck (quickCheck, (<?>))
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)
import Data.ArrayBuffer.Types as AT
import Data.ArrayBuffer.ArrayBuffer as AB
import Data.Base64 as B64

newtype ABuffer = ABuffer AT.ArrayBuffer

buffer :: ABuffer -> AT.ArrayBuffer
buffer (ABuffer b) = b

instance arbitraryArrayBuffer :: Arbitrary ABuffer where
  arbitrary = map (ABuffer <<< AB.fromString) arbitrary

newtype Base64 = Base64 B64.Base64

instance arbitraryBase64 :: Arbitrary Base64 where
  arbitrary = map (Base64 <<< B64.encodeBase64 <<< buffer) arbitrary

main :: Effect Unit
main = do
  quickCheck
    \(Base64 b) ->
      b == (B64.encodeBase64 $ B64.decodeBase64 b)
      <?> "Isormorphic base64 round trip failed"


