// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
    BEGIN LICENSE

    Copyright (C) 2011-2015 elementary Developers

    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License version 3, as published
    by the Free Software Foundation.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranties of
    MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
    PURPOSE.  See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  If not, see <http://www.gnu.org/licenses/>

    END LICENSE
***/


public class Indicators.IndicatorBar : GtkClutter.Actor {
    private EntryList entry_list;

    private Gtk.MenuBar menu_bar;

    public IndicatorBar () {
        Wingpanel.IndicatorManager.get_default ().initialize (Wingpanel.IndicatorManager.ServerType.GREETER);

        entry_list = EntryList.get_default ();

        build_ui ();

        if (Wingpanel.IndicatorManager.get_default ().has_indicators ()) {
            load_indicators ();
        }

        update_list ();

        connect_signals ();
    }

    private void build_ui () {
        var container_widget = (Gtk.Container)this.get_widget ();

        menu_bar = new Gtk.MenuBar ();
        menu_bar.can_focus = true;
        menu_bar.border_width = 0;
        menu_bar.override_background_color (Gtk.StateFlags.NORMAL, {0, 0, 0, 0});
        menu_bar.get_style_context ().add_class (StyleClass.PANEL);
        menu_bar.halign = Gtk.Align.END;

        container_widget.add (menu_bar);
    }

    private void load_indicators () {
        var indicators = Wingpanel.IndicatorManager.get_default ().get_indicators ();

        foreach (Wingpanel.Indicator indicator in indicators) {
            entry_list.add (create_indicator_entry (indicator));
        }
    }

    private void update_list () {
        clear_list ();

        foreach (IndicatorEntry entry in entry_list) {
            if (entry.get_is_visible ())
                menu_bar.append (entry);
        }

        menu_bar.show_all ();
    }

    private void connect_signals () {
        entry_list.list_changed.connect (update_list);

        Wingpanel.IndicatorManager.get_default ().indicator_added.connect ((indicator) => {
            entry_list.add (create_indicator_entry (indicator));
        });
    }

    private IndicatorEntry create_indicator_entry (Wingpanel.Indicator indicator) {
        var indicator_entry = new IndicatorEntry (indicator);

        return indicator_entry;
    }

    private void clear_list () {
        var children = menu_bar.get_children ();

        foreach (var child in children)
            menu_bar.remove (child);
    }
}
