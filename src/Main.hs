{-# LANGUAGE OverloadedStrings #-}
module Main
    ( main
    ) where

import           Control.Monad           (forM_)
import           Data.ByteString.Builder (Builder)
import qualified Data.ByteString.Builder as Builder
import qualified Data.ByteString.Char8   as B
import qualified Data.ByteString.Char8   as BC8
import qualified Data.ByteString.Lazy    as BL
import           Data.Char               (isSpace)
import qualified Data.Csv                as Csv
import qualified Data.HashMap.Strict     as HMS
import           Data.List               (intersperse)
import           Data.Monoid             ((<>))
import qualified Data.Vector             as V
import           System.Environment      (getArgs, getProgName)
import           Text.Printf             (printf)

main :: IO ()
main = do
    args     <- getArgs
    progName <- getProgName
    case args of
        [outDir] -> do
            errOrCsv <- Csv.decodeByName <$> BL.getContents
            case errOrCsv of
                Left err  -> fail err
                Right csv -> writeTextFiles outDir csv
        _        -> do
            fail $ "Usage: " ++ progName ++ " OUTDIR <CSVFILE"

type Row = HMS.HashMap B.ByteString B.ByteString

writeTextFiles
    :: FilePath
    -> (Csv.Header, V.Vector Row)
    -> IO ()
writeTextFiles outDir (header, rows) =
    forM_ (zip [1 ..] (V.toList rows)) $ \(idx, row) -> do
        let filePath = printf "%s/%03d.txt" outDir (idx :: Int)
        BL.writeFile filePath $ Builder.toLazyByteString $ formatRow header row
        putStrLn $ "Wrote " ++  filePath

formatRow :: Csv.Header -> Row -> Builder
formatRow header row =
    mconcat $ intersperse "\n\n" $ map formatCell $ V.toList header
  where
    formatCell :: B.ByteString -> Builder
    formatCell key =
        Builder.byteString key <> "\n" <>
        Builder.byteString (BC8.replicate (B.length key) '=') <> "\n\n" <>
        maybe mempty formatValue (HMS.lookup key row)

    formatValue :: B.ByteString -> Builder
    formatValue =
        mconcat .  intersperse "\n" . map indent .  BC8.lines

    indent :: B.ByteString -> Builder
    indent line
        | BC8.all isSpace line = mempty
        | otherwise            = "  " <> Builder.byteString line
