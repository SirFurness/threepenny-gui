{-# LANGUAGE CPP, PackageImports #-}

import Control.Monad

#ifdef CABAL
import qualified "threepenny-gui" Graphics.UI.Threepenny as UI
import "threepenny-gui" Graphics.UI.Threepenny.Core
#else
import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core
#endif

import Paths
import System.FilePath

{-----------------------------------------------------------------------------
    Main
------------------------------------------------------------------------------}
main :: IO ()
main = do
    startGUI Config
        { tpPort       = 10000
        , tpCustomHTML = Nothing
        , tpStatic     = ""
        } setup

setup :: Window -> IO ()
setup window = do
    return window # set title "Drawing"
    
    canvas <- UI.canvas
        # set UI.height 400
        # set UI.width  400
        # set style [("border", "solid black 1px")]
    
    getBody window #+ [column [element canvas, string "Click to places images."]]
    
    dir <- getStaticDir
    url <- loadFile window "image/png" (dir </> "game" </> "BlackMage" <.> "png")
    img <- UI.img # set UI.src url
    
    let positions = [(x,y) | x <- [0,20..300], y <- [0,20..300]] :: [(Int,Int)]
    on UI.click canvas $ const $ forM_ positions $
        \xy -> UI.drawImage img xy canvas
