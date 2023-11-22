module Main where

import Data.Char
import System.Environment

toc :: FilePath -> Int -> IO String
toc inF indent = fmap (makeToc indent) (readFile inF)

makeToc :: Int -> String -> String
makeToc indent content = newToc ++ content
  where
    headings = map getHeading (headingLines $ lines content)
      where
        headingLines = filter (\x -> not (null x) && head (trimStart x) == '#')
        getHeading line = (hLvl - 1, restOfLine line)
          where
            hLvl = length $ takeWhile (== '#') line
            restOfLine = trimStart . drop hLvl
    newToc = "# Table of Contents\n\n" ++ concatMap tocEntry headings ++ "\n"
      where
        tocEntry (hNr, line) = makeIndent ++ makeLinkName ++ makeLink
          where
            makeLink = "(#" ++ linkName line ++ ")\n"
              where
                linkName = map ((\x -> if isSpace x then '-' else x) . toLower)
            makeIndent = replicate (indent * hNr) ' '
            makeLinkName = "- [" ++ line ++ "]"

trimStart :: String -> String
trimStart = dropWhile isSpace

help :: String
help =
  "mdtoc: Generate a table of contents for markdown files.\n\n\
  \Usage:  mdtoc FILE [-h] [-i COUNT]\n\
  \\n\
  \  FILE                 path to a markdown file\n\
  \  -i COUNT             use COUNT spaces for indentation\n\
  \  -h                   show this help message"

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["-h"] -> putStrLn help
    [file, "-i", ilevel] -> toc file (read ilevel :: Int) >>= putStrLn
    [file] -> toc file 2 >>= putStrLn
    _ -> fail "invalid arguments, use `-h` for help message"
  return ()
