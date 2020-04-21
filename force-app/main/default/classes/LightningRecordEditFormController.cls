public class LightningRecordEditFormController {

	@AuraEnabled
	public static List<LayoutSection> getPageLayoutFields(String ObjectNameLayout) {

		List<LayoutSection> lstSections = new List<LayoutSection>();

		try {
			// Provide the page layout name here
			// You can give multiple page layout names here as well
			List<String> componentNameList = new List<String>{ObjectNameLayout};
			// Retrieve page layout details
			List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);
			Metadata.Layout contLayout = (Metadata.Layout) components.get(0);
			system.debug('contLayout :: ' + contLayout);

			// We are going to find the fields names and will keep them according to columns so
			// we can show them as per page layout
			for( Metadata.LayoutSection ls : contLayout.layoutSections ) {

				LayoutSection section = new LayoutSection( ls.label, ls.layoutColumns.size() );

				List<LayoutColumn> lstColumns = new List<LayoutColumn>();
				Integer maxFieldsInColumn = 0;
				for( Metadata.LayoutColumn lc : ls.layoutColumns ) {

					LayoutColumn column = new LayoutColumn();
					// check if there are fields available in that column
					if( lc.layoutItems != null ) {
						// Get the max number of fields in a column to preserve the alignment
						if( maxFieldsInColumn < lc.layoutItems.size() ) {
							maxFieldsInColumn = lc.layoutItems.size();
						}
						for( Metadata.LayoutItem li : lc.layoutItems ) {

							// Pass the LayoutItem object in the LayoutField consturctor
							column.lstFields.add( new LayoutField( li ) );
						}
					}
					// No need to add a column in the section if there is no field available
					if( column.lstFields.size() > 0 ) {
						lstColumns.add( column );
					}
				}
				system.debug('lstColumns :: ' + lstColumns);
				// Now, we need to arrange the fields in section so we can use them in the iteration
				// on the component so we will have to arrange them in the order
				if( maxFieldsInColumn > 0 ) {
					for( Integer i = 0; i < maxFieldsInColumn; i++ ) {
						for( Integer j = 0; j < lstColumns.size(); j++ ){
							if( lstColumns[j].lstFields.size() > i ) {
								section.lstFields.add( lstColumns[j].lstFields[i] );
							}
							else {
								section.lstFields.add( new LayoutField() );
							}
						}
					}
				}

				lstSections.add( section );
				system.debug('lstSections :::: ' + lstSections);
			}
		}
		catch( Exception e ){
			System.debug(e.getLineNumber() + ' : ' + e.getMessage() );
		}
		system.debug('lstSections Final :::: ' + lstSections);
		return lstSections;
	}

	public class LayoutSection {
		@AuraEnabled public String label;
		@AuraEnabled public List<LayoutField> lstFields;
		@AuraEnabled public Integer totalColumns;
		public LayoutSection( String label, Integer totalColumns ) {
			this.label = label;
			this.totalColumns = totalColumns;
			this.lstFields = new List<LayoutField>();
		}
	}

	private class LayoutColumn {
		private List<LayoutField> lstFields;
		public LayoutColumn() {
			this.lstFields = new List<LayoutField>();
		}
	}

	public class LayoutField {
		@AuraEnabled public String fieldName;
		@AuraEnabled public Boolean isRequired;
		@AuraEnabled public Boolean isReadOnly;

		public LayoutField() {}

		public LayoutField( Metadata.LayoutItem li ) {

			this.fieldName = li.field;
			if( li.behavior == Metadata.UiBehavior.Required ) {
				this.isRequired = true;
			}
			else if( li.behavior == Metadata.UiBehavior.ReadOnly ) {
				this.isReadOnly = true;
			}
		}
	}
}