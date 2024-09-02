module Iri.QuasiQuoter
  ( uri,
    httpUri,
    iri,
    httpIri,
  )
where

import Data.Attoparsec.ByteString qualified as B
import Data.Attoparsec.Text qualified as C
import Iri.Parsing.Attoparsec.ByteString qualified as A
import Iri.Parsing.Attoparsec.Text qualified as D
import Iri.Prelude hiding (exp)
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax

exp :: (String -> Q Exp) -> QuasiQuoter
exp exp =
  QuasiQuoter exp unsupported unsupported unsupported
  where
    unsupported _ =
      fail "Not supported"

-- |
-- 'Iri' literal from ASCII representation.
uri :: QuasiQuoter
uri =
  exp $ \string ->
    case B.parseOnly (A.uri <* B.endOfInput) (fromString string) of
      Right uri -> lift uri
      Left error -> fail (showString "URI parsing: " error)

-- |
-- 'HttpIri' literal from ASCII representation.
httpUri :: QuasiQuoter
httpUri =
  exp $ \string ->
    case B.parseOnly (A.httpUri <* B.endOfInput) (fromString string) of
      Right uri -> lift uri
      Left error -> fail (showString "HTTP URI parsing: " error)

-- |
-- 'Iri' literal from IRI representation.
iri :: QuasiQuoter
iri =
  exp $ \string ->
    case C.parseOnly (D.iri <* C.endOfInput) (fromString string) of
      Right iri -> lift iri
      Left error -> fail (showString "IRI parsing: " error)

-- |
-- 'HttpIri' literal from IRI representation.
httpIri :: QuasiQuoter
httpIri =
  exp $ \string ->
    case C.parseOnly (D.httpIri <* C.endOfInput) (fromString string) of
      Right iri -> lift iri
      Left error -> fail (showString "HTTP IRI parsing: " error)
