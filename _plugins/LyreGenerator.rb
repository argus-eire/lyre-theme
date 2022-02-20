module LyreGenerator
    ##
    # Generates all special pages for the Lyre theme
    class Generator < Jekyll::Generator
        public
            # safe true
            priority :lowest
            
            # main action, entry point
            def generate(site)
                @site = site

                # get literally all pages listed as episodes
                # it's a magic trick you'll probably never get enough of.
                # need to shallow copy that collection so we don't end up
                # with an infinite loop
                episodes =  site.collections["episodes"].docs.clone

                # we can iterate over those
                for episode in episodes
                    generate_all(episode)
                end
            end

        private
            # helpers go here, ostensibly

            ##
            # runs all the generators, while respecting conditions
            # mostly wanted to get the deeply nested tree under control so
            # I extracted this. Sorry.
            def generate_all(doc)
                # episode.rss - needed by podlove
                if (doc.data["generators"]["episode"]["generate"])
                    swpDest = doc.data["generators"]["episode"]["destination"]

                    if ("default" == swpDest)
                        swpDest = "/res/podlove/episode/" + doc.data["permalink"] + "/episode.json"
                    end

                    generate_episode_json(doc, swpDest)
                end

                # episode credit/summary/etc - makes youtube/etc happy.
                if (doc.data["generators"]["credits"]["generate"])
                    swpDest = doc.data["generators"]["credits"]["destination"]

                    if ("default" == swpDest)
                        swpDest = "/res/credits/" + doc.data["permalink"] + ".txt"
                    end

                    generate_episode_credits(doc, swpDest)
                end
            end

            ##
            # Creates credits file from an episode file
            def generate_episode_credits(doc, permalink)
                swp = generateNewCloneOfDoc(doc, "txt/credits", permalink)
                @site.collections["episodes"].docs << swp
            end

            ##
            # Creates episode.json for Podlove from an episode file
            def generate_episode_json(doc, permalink)
                swp = generateNewCloneOfDoc(doc, "podlove/episode", permalink)
                @site.collections["episodes"].docs << swp
            end

            ##
            # Clones a document on request
            def cloneDoc(orig)
                # create deep copied clone of page
                swp = Jekyll::Document.new(orig.path, { :site => @site, :collection => @site.collections["episodes"]})
                swp.read(orig.data)
                swp.content  = orig.content
                
                # and now we have to wipe a couple things to protect things from
                # worse outcomes
                swp.data["categories"] = []
                swp.data["tags"] = []
                swp.data["layout"] = ""

                # if you get here because "why do I have a file named
                # "err_LyreGenerator", the answer is that you left the generator
                # on but didn't set some sort of sane permalink. Fix it.
                swp.data["permalink"] = "err_LyreGenerator"

                return swp
            end

            ##
            # generates a new clone of source with the given layout and
            # permalink
            #
            # look, I know my names suck, but it does what it says.
            def generateNewCloneOfDoc(source, layout, permalink)
                swp = cloneDoc(source)
                swp.data["layout"] = layout
                swp.data["permalink"] = permalink
                return swp
            end
    end
end