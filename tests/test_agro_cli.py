import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("agro_cli", ROOT / "src" / "agro_cli.py")
AGRO = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(AGRO)


class AgroRetrieverTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.documents = AGRO.load_corpus()

    def test_corpus_is_nonempty_and_multilingual(self):
        self.assertGreaterEqual(len(self.documents), 12)
        languages = {document["language"] for document in self.documents}
        self.assertTrue({"sw", "fr", "en"}.issubset(languages))

    def test_fall_armyworm_query_retrieves_relevant_note(self):
        matches = AGRO.retrieve(
            "Mahindi yana mashimo na kinyesi ndani ya moyo wa mmea",
            self.documents,
            limit=3,
        )
        ids = {document["id"] for document in matches}
        self.assertIn("fall-armyworm-sw", ids)

    def test_unrelated_query_returns_no_note(self):
        self.assertEqual(AGRO.retrieve("quantum chromodynamics", self.documents), [])

    def test_prompt_preserves_farmer_question_and_sources(self):
        question = "Nifanye nini kwa mahindi yangu?"
        matches = AGRO.retrieve(question, self.documents, limit=2)
        prompt = AGRO.build_prompt(question, matches)
        self.assertIn(question, prompt)
        self.assertIn("FARMER QUESTION", prompt)


if __name__ == "__main__":
    unittest.main()
