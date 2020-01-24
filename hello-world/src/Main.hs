{-# LANGUAGE TypeApplications #-}

module Main where

import qualified Aws.Api.Gateway as GW
import Aws.Lambda
import Control.Lens ((.~), (?~), (^.))
import Data.List (lookup)
import Network.HTTP.Types.Header (Header, hContentType)
import Network.HTTP.Types.Status (ok200)

main :: IO ()
main =
  runLambda $ \LambdaOptions {eventObject} -> do
    let request :: GW.ProxyRequest Text
        request = decodeObj eventObject
        name = join . lookup "name" $ request ^. GW.requestQueryStringParameters
    return . Right . LambdaResult . encodeObj $
      GW.response @Text ok200
        & GW.responseBody ?~ greet name
        & GW.proxyResponseHeaders .~ [(hContentType, "text/plain") :: Header]

greet :: Maybe ByteString -> Text
greet Nothing = "Hello stranger!"
greet (Just name) = "Hello " <> decodeUtf8 name <> "!"