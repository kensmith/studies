#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <libxml++/libxml++.h>
#include "log_t.hpp"

int main(int /* argc */, char** /* argv */)
{
   std::locale::global(std::locale(""));

   try
   {
      xmlpp::DomParser parser;
      parser.set_throw_messages(true);
      parser.set_substitute_entities(true);
      parser.parse_file("example.xml");
      if (!parser)
      {
         throw "wtf";
      }
      xmlpp::Node* root = parser.get_document()->get_root_node();
      xmlpp::NodeSet nodes = root->find("/example/examplechildchild_of_child");
      for (auto node : nodes)
      {
         xmlpp::Node::NodeList children = node->get_children();
         for (auto child : children)
         {
            ooo(iii)
               << "name = "
               << child->get_name()
               << ", line = "
               << child->get_line();
            const xmlpp::ContentNode* content = dynamic_cast<const xmlpp::ContentNode*>(child);
            if (content)
            {
               ooo(iii)
                  << "content = "
                  << content->get_content();
            }
            const xmlpp::CommentNode* comment = dynamic_cast<const xmlpp::CommentNode*>(child);
            if (comment)
            {
               ooo(iii)
                  << "comment = "
                  << comment->get_content();
            }
            const xmlpp::TextNode* text = dynamic_cast<const xmlpp::TextNode*>(child);
            if (text)
            {
               ooo(iii)
                  << "text = "
                  << text->get_content();
            }
            const xmlpp::Element* element = dynamic_cast<const xmlpp::Element*>(child);
            if (element)
            {
               ooo(iii)
                  << "element";
               xmlpp::Element::AttributeList list = element->get_attributes();
               for (auto attribute : list)
               {
                  ooo(iii)
                     << "name = "
                     << attribute->get_name()
                     << ", value = "
                     << attribute->get_value();
               }
            }
            const xmlpp::CdataNode* cdata = dynamic_cast<const xmlpp::CdataNode*>(child);
            if (cdata)
            {
               ooo(iii)
                  << "cdata";
            }
         }
      }
   }
   catch(const std::exception& e)
   {
      ooo(eee)
         << e.what();
      return EXIT_FAILURE;
   }
   catch(const char* e)
   {
      ooo(eee)
         << e;
      return EXIT_FAILURE;
   }
   return EXIT_SUCCESS;
}

