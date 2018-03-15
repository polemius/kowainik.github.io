import Data.Monoid ((<>))
import Hakyll (applyAsTemplate, compile, compressCssCompiler, copyFileCompiler, create,
               defaultContext, hakyll, idRoute, loadAndApplyTemplate, makeItem, match,
               relativizeUrls, route, templateBodyCompiler, (.||.))

import Kowainik.Project (makeProjectContext)
import Kowainik.Social (makeSocialContext)
import Kowainik.Team (makeTeamContext)

main :: IO ()
main = hakyll $ do
    match ("images/**" .||. "fonts/**" .||. "js/*" ) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    create ["index.html"] $ do
        route idRoute
        compile $ do
            let ctx = makeProjectContext <> makeSocialContext <> makeTeamContext <> defaultContext
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/project.html" ctx
                >>= loadAndApplyTemplate "templates/team.html" ctx
                >>= loadAndApplyTemplate "templates/main.html" ctx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler
