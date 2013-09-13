hi
hey:)

# Goat Latin is a made-up language based off of English, sort of like Pig Latin. The rules of Goat Latin are as follows:
# 1. If a word begins with a consonant, remove the first letter and append it to the end, then add 'ma'.
#    For example, the word 'goat' becomes 'oatgma'.
# 2. If a word begins with a vowel, append 'ma' to the end of the word.
#    For example, the word 'I' becomes 'Ima'.
# 3. Add one letter "a" to the end of each word per its word index in the sentence, starting with 1.
#    That is, the first word gets "a" added to the end, the second word gets "aa" added to the end,
#    the third word in the sentence gets "aaa" added to the end, and so on.

# Write a function that, given a string of words making up one sentence, returns that sentence in Goat Latin. For example:
#
#  string_to_goat_latin('I speak Goat Latin')
#
# would return: 'Imaa peaksmaaa oatGmaaaa atinLmaaaaa'

std::vector<std::string> getwords(const std::string& sentence)
{
   boost::tokenizer<std::string> tokenizer(" ");
   std::vector<std::string> result = tokenizer.tokenize(sentence);
}

bool is_consonant(const char* c)
{
   // TODO
}

std::string string_to_goat_latin(const std::string& sentence)
{
   std::stringstream ss;
   std::vector<std::string> words = getwords(sentence);
   int i = 1;
   for (auto word : words)
   {
      if (is_consonant(word[0]))
      {
         ss << word.slice(1,word.end());
         ss << word[0];
      }
      else
      {
         ss << word;
      }
      
      ss << "ma";
      
      // here
      ss << std::string('a', i);
      
      if (i < words.size())
      {
         ss << " ";
      }
   }
   return ss.str();
}

# You will be supplied with two data files in CSV format. The first file contains 
# statistics about various dinosaurs. The second file contains additional data.
#
# Given the following formula,
#
# speed = ((stride length / leg length) - 1) * √(leg length * g)
# Where g = 9.8 m/s^2 (gravitational constant)
#
# Write a program to read in the data files from disk, it must then print the names
# of bipedal dinosaurs from fastest to slowest. Do not print any other information.

# $ cat statistics.csv
# NAME,LEG-LENGTH,DIET
# Hadrosaurus,1.2,herbivore
# Struthiomimus,0.92,omnivore
# Velociraptor,1.0,carnivore
# Euoplocephalus,1.6,herbivore
# Stegosaurus,1.40,herbivore
# Tyrannosaurus Rex,2.5,carnivore

# $ cat classifications.csv
# NAME,STRIDE-LENGTH,STANCE
# Euoplocephalus,1.87,quadrupedal
# Stegosaurus,1.90,quadrupedal
# Tyrannosaurus Rex,5.76,bipedal
# Hadrosaurus,1.4,bipedal
# Struthiomimus,1.34,bipedal
# Velociraptor,2.72,bipedal

statistics = csv.reader("statistics.csv")
classifications = csv.reader("classifications.csv")

bipeds = {}
for record in classifications:
   if record[2] == "bipedal":
      bipeds[record[0]] = [record[1]]

g = 9.8
for record in statistics:
   if bipeds.keyexists(record[0]):
      bipeds[record[0]].append((bipeds[record[0]] / record[1] - 1) * math.sqrt(record[1] * g))
      
sorted = []
for key in bipeds.keys():
   if biped[key].size() == 2:
      sorted.append((biped[key][0], key))
   
def less_than(t1, t2):
   return t1[0] < t2[0]
   
sorted.sort(less_than)

for pair in sorted:
   print(pair[1])
 


